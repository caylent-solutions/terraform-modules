package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
)

// For testing purposes
var coverageDir = "tmp/coverage"
var execCommand = exec.Command
var stdout = os.Stdout
var stderr = os.Stderr

// CoverageGroup represents a group of tests to run on
type CoverageGroup struct {
	Name       string `json:"name"`
	Emoji      string `json:"emoji"`
	OutputFile string `json:"outputFile"`
	TestPath   string `json:"testPath"`
	CoverPkg   string `json:"coverPkg"`
}

// Config represents the structure of the monorepo-config.json file
type Config struct {
	CoverageGroups []CoverageGroup `json:"coverage_groups"`
}

// CoverageResult represents the coverage result for a module
type CoverageResult struct {
	Name       string  `json:"name"`
	Coverage   float64 `json:"coverage"`
	Statements int     `json:"statements"`
	Error      string  `json:"error,omitempty"`
}

// CoverageSummary represents the overall coverage summary
type CoverageSummary struct {
	Modules []CoverageResult `json:"modules"`
	Total   float64          `json:"total"`
	Errors  int              `json:"errors"`
}

func main() {
	// Define flags
	noCoverage := flag.Bool("no-coverage", false, "Run tests without collecting coverage data")
	coverageText := flag.Bool("coverage-text", false, "Output coverage as text")
	coverageJSON := flag.Bool("coverage-json", false, "Output coverage as JSON")
	flag.Parse()

	// Get JSON file path from command line
	args := flag.Args()
	if len(args) < 1 {
		fmt.Fprintln(stderr, "Error: JSON file path must be provided")
		os.Exit(1)
	}

	jsonFilePath := args[0]

	// Read JSON from file
	jsonData, err := os.ReadFile(jsonFilePath)
	if err != nil {
		fmt.Fprintf(stderr, "Error reading config file: %v\n", err)
		os.Exit(1)
	}

	var config Config
	if err := json.Unmarshal(jsonData, &config); err != nil {
		fmt.Fprintf(stderr, "Error parsing config file: %v\n", err)
		os.Exit(1)
	}

	groups := config.CoverageGroups
	if len(groups) == 0 {
		fmt.Fprintln(stderr, "Error: No coverage groups provided in the config file")
		os.Exit(1)
	}

	// Create coverage directory if collecting coverage
	if !*noCoverage {
		if err := os.MkdirAll(coverageDir, 0755); err != nil {
			fmt.Fprintf(stderr, "Error creating coverage directory: %v\n", err)
			os.Exit(1)
		}
	}

	// Run tests for each group
	moduleResults := make([]CoverageResult, 0, len(groups))
	errorCount := 0

	for _, group := range groups {
		fmt.Fprintf(stderr, "%s Running tests for %s...\n", group.Emoji, group.Name)

		var coverage float64
		var statements int
		var testErr error

		if *noCoverage {
			// Just run the tests without coverage
			testErr = runTest(group.TestPath)
		} else {
			// Run tests with coverage
			coverage, statements, testErr = runTestWithCoverage(group.OutputFile, group.TestPath)
		}

		result := CoverageResult{
			Name:       group.Name,
			Coverage:   coverage,
			Statements: statements,
		}

		if testErr != nil {
			errorCount++
			errorMsg := fmt.Sprintf("Error running tests: %v", testErr)
			result.Error = errorMsg

			fmt.Fprintf(stderr, "❌ %s\n", errorMsg)
		}

		moduleResults = append(moduleResults, result)

		// If text output and collecting coverage, print coverage details
		if *coverageText && !*noCoverage {
			outputPath := filepath.Join(coverageDir, group.OutputFile)
			if fileExists(outputPath) {
				coverageCmd := execCommand("bash", "-c", fmt.Sprintf("go tool cover -func=../../%s", outputPath))
				coverageCmd.Dir = group.TestPath
				coverageOutput, _ := coverageCmd.CombinedOutput()
				fmt.Fprintf(stderr, "\nCoverage for %s:\n%s\n", group.Name, string(coverageOutput))
			}
		}
	}

	// If not collecting coverage, we're done
	if *noCoverage {
		if errorCount > 0 {
			os.Exit(1)
		}
		return
	}

	// Calculate weighted average coverage
	var totalCoveredStatements float64
	var totalStatements int
	for _, result := range moduleResults {
		totalCoveredStatements += float64(result.Statements) * result.Coverage / 100
		totalStatements += result.Statements
	}

	var averageCoverage float64
	if totalStatements > 0 {
		averageCoverage = totalCoveredStatements / float64(totalStatements) * 100
	}

	// Create summary
	summary := CoverageSummary{
		Modules: moduleResults,
		Total:   averageCoverage,
		Errors:  errorCount,
	}

	// Output based on format
	if *coverageText {
		fmt.Fprintf(stderr, "\nSummary:\n")
		fmt.Fprintf(stderr, "%-40s %-10s %-10s\n", "Module", "Coverage", "Statements")
		fmt.Fprintf(stderr, "%-40s %-10s %-10s\n", strings.Repeat("-", 40), strings.Repeat("-", 10), strings.Repeat("-", 10))

		for _, result := range moduleResults {
			statusPrefix := "  "
			if result.Error != "" {
				statusPrefix = "❌ "
			}
			fmt.Fprintf(stderr, "%s%-38s %9.1f%% %10d\n", statusPrefix, result.Name, result.Coverage, result.Statements)
		}

		fmt.Fprintf(stderr, "%-40s %-10s %-10s\n", strings.Repeat("-", 40), strings.Repeat("-", 10), strings.Repeat("-", 10))
		fmt.Fprintf(stderr, "%-40s %9.1f%% %10d\n", "Total", averageCoverage, totalStatements)

		if errorCount > 0 {
			fmt.Fprintf(stderr, "\n❌ %d test modules failed\n", errorCount)
		}
	} else if *coverageJSON {
		// Output as JSON to stdout only
		outputJSON, err := json.MarshalIndent(summary, "", "  ")
		if err != nil {
			fmt.Fprintf(stderr, "Error creating JSON output: %v\n", err)
			os.Exit(1)
		}
		fmt.Fprintln(stdout, string(outputJSON))
	}

	// Exit with error if any test failed
	if errorCount > 0 {
		os.Exit(1)
	}
}

func runTest(testPath string) error {
	// Check if the directory exists
	if _, err := os.Stat(testPath); os.IsNotExist(err) {
		return fmt.Errorf("directory %s does not exist", testPath)
	}

	// Run the tests
	cmd := execCommand("bash", "-c", fmt.Sprintf("cd %s && go test -v", testPath))
	cmd.Stdout = stderr
	cmd.Stderr = stderr

	return cmd.Run()
}

func runTestWithCoverage(outputFile, testPath string) (float64, int, error) {
	outputPath := filepath.Join(coverageDir, outputFile)

	// Check if the directory exists
	if _, err := os.Stat(testPath); os.IsNotExist(err) {
		return 0.0, 0, fmt.Errorf("directory %s does not exist", testPath)
	}

	// First run go test with -count=1 to get accurate statement count
	cmdCount := execCommand("bash", "-c", fmt.Sprintf("cd %s && go test -cover -count=1", testPath))
	outputCount, err := cmdCount.CombinedOutput()
	outputCountStr := string(outputCount)

	// If there was an error in the first run, return it
	if err != nil {
		return 0.0, 0, fmt.Errorf("%v: %s", err, outputCountStr)
	}

	// Extract statement count
	statements := extractStatementCount(outputCountStr)

	// Now run with coverage profile
	cmd := execCommand("bash", "-c", fmt.Sprintf("cd %s && go test -cover -coverprofile=../../%s", testPath, outputPath))
	output, cmdErr := cmd.CombinedOutput()
	outputStr := string(output)

	// Extract coverage percentage
	coverageStr := extractCoveragePercentage(outputStr)
	coverage := parseCoveragePercentage(coverageStr)

	// If we couldn't get statement count from first run, try from second run
	if statements == 0 {
		statements = extractStatementCount(outputStr)
	}

	// If we still don't have statement count, get it from the coverage file
	if statements == 0 && fileExists(outputPath) {
		statements = countLinesInFile(outputPath) - 1 // Subtract 1 for the header line
	}

	// If statements is still 0, set it to 1 to avoid division by zero
	if statements == 0 {
		statements = 1
	}

	return coverage, statements, cmdErr
}

func extractCoveragePercentage(output string) string {
	// Look for coverage: XX.X% of statements
	lines := strings.Split(output, "\n")
	for _, line := range lines {
		if strings.Contains(line, "coverage:") {
			parts := strings.Fields(line)
			for _, part := range parts {
				if strings.HasSuffix(part, "%") {
					return part
				}
			}
		}
	}
	return "0.0%"
}

func parseCoveragePercentage(coverageStr string) float64 {
	// Remove % sign and convert to float
	coverageStr = strings.TrimSuffix(coverageStr, "%")
	var coverage float64
	fmt.Sscanf(coverageStr, "%f", &coverage)
	return coverage
}

func extractStatementCount(output string) int {
	// Look for "of X statements"
	re := regexp.MustCompile(`of (\d+) statements`)
	matches := re.FindStringSubmatch(output)
	if len(matches) > 1 {
		count, err := strconv.Atoi(matches[1])
		if err == nil {
			return count
		}
	}
	return 0
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func countLinesInFile(path string) int {
	data, err := os.ReadFile(path)
	if err != nil {
		return 0
	}
	return len(strings.Split(string(data), "\n"))
}
