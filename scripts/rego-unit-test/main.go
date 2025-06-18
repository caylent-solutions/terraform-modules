package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
)

//
// ---------- Data Structures ----------
//

// Config holds test directories, policy mapping, and helpers path.
type Config struct {
	RegoTests      []string          `json:"rego_tests"`       // List of unit test directories
	RegoPolicyDirs map[string]string `json:"rego_policy_dirs"` // Mapping of test dir → policy dir
	RegoHelpersDir string            `json:"rego_helpers_dir"` // Path to helpers.rego
}

// CoverageData represents the root of OPA JSON coverage output.
type CoverageData struct {
	Files           map[string]FileCoverage `json:"files"`             // File-specific coverage
	CoveredLines    int                     `json:"covered_lines"`     // Count of lines covered
	NotCoveredLines int                     `json:"not_covered_lines"` // Count of lines missed
	Coverage        float64                 `json:"coverage"`          // Coverage percent (0–100)
}

// FileCoverage contains coverage info for one `.rego` file.
type FileCoverage struct {
	Covered         []LineRange `json:"covered"`           // Ranges of lines covered
	NotCovered      []LineRange `json:"not_covered"`       // Ranges of lines not covered
	CoveredLines    int         `json:"covered_lines"`     // Count of covered lines
	NotCoveredLines int         `json:"not_covered_lines"` // Count of uncovered lines
	Coverage        float64     `json:"coverage"`          // File-level percent coverage
}

// LineRange represents a range of lines (start to end)
type LineRange struct {
	Start Position `json:"start"` // Start line
	End   Position `json:"end"`   // End line
}

// Position represents a line number in a file.
type Position struct {
	Row int `json:"row"` // Line number
}

// ModuleCoverage aggregates coverage across a logical module.
type ModuleCoverage struct {
	Name       string  `json:"name"`       // Logical module name (e.g., dir path)
	Coverage   float64 `json:"coverage"`   // Percent covered
	Statements int     `json:"statements"` // Total lines
}

// JSONReport defines the structured JSON summary format.
type JSONReport struct {
	Modules []ModuleCoverage `json:"modules"` // Per-module summaries
	Total   float64          `json:"total"`   // Overall percent coverage
	Errors  int              `json:"errors"`  // Count of failures (always 0 here)
}

//
// ---------- Main Entrypoint ----------
//

func main() {
	// Define CLI flags
	noCoverage := flag.Bool("no-coverage", false, "Run tests without coverage")
	coverageText := flag.Bool("coverage-text", false, "Output coverage in text format")
	coverageJSON := flag.Bool("coverage-json", false, "Output coverage in JSON format")
	dataPath := flag.String("data-path", ".", "Path to the data directory")
	flag.Parse()

	// Expect config file path as final argument
	args := flag.Args()
	if len(args) < 1 {
		fmt.Fprintln(os.Stderr, "Error: Config file path is required")
		os.Exit(1)
	}
	configPath := args[0]

	// Read and parse JSON config
	config, err := readConfig(configPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading config file: %v\n", err)
		os.Exit(1)
	}

	// Run test logic
	success := runTests(config, *dataPath, *noCoverage, *coverageText, *coverageJSON)
	if !success {
		os.Exit(1)
	}
}

//
// ---------- Config Reader ----------
//

// readConfig loads and unmarshals the monorepo-config.json file.
func readConfig(path string) (*Config, error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var config Config
	err = json.Unmarshal(data, &config)
	return &config, err
}

//
// ---------- Test Runner ----------
//

// runTests executes tests and handles output generation (JSON/text).
func runTests(config *Config, dataPath string, noCoverage, coverageText, coverageJSON bool) bool {
	allSuccess := true
	var coverageFiles []string

	// Full path to helpers directory
	helpersDir := filepath.Join(dataPath, config.RegoHelpersDir)

	for _, testPath := range config.RegoTests {
		fmt.Fprintf(os.Stderr, "Running Rego tests in %s...\n", testPath)

		// Determine associated policy directory
		policyDir := config.getPolicyDir(testPath)

		// Build `opa test` arguments
		args := []string{"test"}
		if noCoverage {
			args = append(args, "-v")
		} else {
			if coverageText {
				args = append(args, "--coverage")
			} else if coverageJSON {
				args = append(args, "--coverage", "--format=json")
			}
		}
		args = append(args, testPath, policyDir, helpersDir)

		// Run the command
		cmd := exec.Command("opa", args...)
		var output []byte
		var err error

		// Capture or display output depending on mode
		if noCoverage {
			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr
			err = cmd.Run()
		} else {
			output, err = cmd.CombinedOutput()
		}

		// Handle test failures
		if err != nil {
			if !noCoverage {
				fmt.Fprintln(os.Stderr, string(output))
			}
			fmt.Fprintf(os.Stderr, "Error running tests in %s: %v\n", testPath, err)
			allSuccess = false
		}

		// Save raw coverage report
		if !noCoverage && (coverageText || coverageJSON) {
			coverageFile := filepath.Join("tmp", "coverage",
				fmt.Sprintf("rego-coverage-%s.%s", strings.ReplaceAll(testPath, "/", "-"), getFileExtension(coverageJSON)))
			err = ioutil.WriteFile(coverageFile, output, 0644)
			if err != nil {
				fmt.Fprintf(os.Stderr, "Error writing coverage file %s: %v\n", coverageFile, err)
			}
			coverageFiles = append(coverageFiles, coverageFile)
		}
	}

	// Emit text summary if requested
	if coverageText && len(coverageFiles) > 0 {
		err := GenerateTextCoverageReport(coverageFiles)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error generating coverage report: %v\n", err)
		}
	}

	// Emit structured JSON summary if requested
	if coverageJSON && len(coverageFiles) > 0 {
		err := GenerateJSONCoverageReport(coverageFiles)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error generating JSON summary: %v\n", err)
		}
	}

	return allSuccess
}

//
// ---------- Utility Helpers ----------
//

// getPolicyDir returns the policy dir mapped to a test dir
func (c *Config) getPolicyDir(testPath string) string {
	if dir, ok := c.RegoPolicyDirs[testPath]; ok {
		return dir
	}
	return ""
}

// getFileExtension returns file extension for a coverage format
func getFileExtension(isJSON bool) string {
	if isJSON {
		return "json"
	}
	return "txt"
}

//
// ---------- Text Report Generator ----------
//

// GenerateTextCoverageReport prints human-readable summary to stderr.
func GenerateTextCoverageReport(coverageFiles []string) error {
	var totalCoveredLines, totalNotCoveredLines int
	var moduleCoverages []ModuleCoverage

	for _, file := range coverageFiles {
		// Read and parse raw coverage file
		data, err := ioutil.ReadFile(file)
		if err != nil {
			return fmt.Errorf("error reading coverage file %s: %v", file, err)
		}
		var coverage CoverageData
		err = json.Unmarshal(data, &coverage)
		if err != nil {
			return fmt.Errorf("error parsing coverage data from %s: %v", file, err)
		}

		// Aggregate totals
		moduleName := extractModuleName(file)
		totalCoveredLines += coverage.CoveredLines
		totalNotCoveredLines += coverage.NotCoveredLines

		moduleCoverages = append(moduleCoverages, ModuleCoverage{
			Name:       moduleName,
			Coverage:   coverage.Coverage,
			Statements: coverage.CoveredLines + coverage.NotCoveredLines,
		})

		// Print file-level details
		fmt.Fprintf(os.Stderr, "\nCoverage for %s:\n", moduleName)
		var filePaths []string
		for filePath := range coverage.Files {
			filePaths = append(filePaths, filePath)
		}
		sort.Strings(filePaths)
		for _, filePath := range filePaths {
			fileCoverage := coverage.Files[filePath]
			if fileCoverage.CoveredLines == 0 && fileCoverage.NotCoveredLines == 0 {
				continue
			}
			fmt.Fprintf(os.Stderr, "%-70s %6.1f%%\n", filePath, fileCoverage.Coverage)
		}
		fmt.Fprintf(os.Stderr, "%-70s %6.1f%%\n", "total:", coverage.Coverage)
	}

	// Print module-level summary
	totalLines := totalCoveredLines + totalNotCoveredLines
	var totalCoverage float64
	if totalLines > 0 {
		totalCoverage = float64(totalCoveredLines) / float64(totalLines) * 100
	}

	fmt.Fprintf(os.Stderr, "\n\nSummary:\n")
	fmt.Fprintf(os.Stderr, "%-40s %10s %10s\n", "Module", "Coverage", "Statements")
	fmt.Fprintf(os.Stderr, "%-40s %10s %10s\n", "----------------------------------------", "----------", "----------")
	sort.Slice(moduleCoverages, func(i, j int) bool {
		return moduleCoverages[i].Name < moduleCoverages[j].Name
	})
	for _, mc := range moduleCoverages {
		fmt.Fprintf(os.Stderr, "  %-38s %9.1f%% %10d\n", mc.Name, mc.Coverage, mc.Statements)
	}
	fmt.Fprintf(os.Stderr, "%-40s %9.1f%% %10d\n", "Total", totalCoverage, totalLines)

	return nil
}

//
// ---------- JSON Report Generator ----------
//

// GenerateJSONCoverageReport emits a structured summary to stdout.
func GenerateJSONCoverageReport(coverageFiles []string) error {
	var totalCoveredLines, totalNotCoveredLines int
	var moduleCoverages []ModuleCoverage

	for _, file := range coverageFiles {
		// Read and parse raw file
		data, err := ioutil.ReadFile(file)
		if err != nil {
			return fmt.Errorf("error reading coverage file %s: %v", file, err)
		}
		var coverage CoverageData
		err = json.Unmarshal(data, &coverage)
		if err != nil {
			return fmt.Errorf("error parsing coverage data from %s: %v", file, err)
		}

		// Add module data
		moduleCoverages = append(moduleCoverages, ModuleCoverage{
			Name:       extractModuleName(file),
			Coverage:   coverage.Coverage,
			Statements: coverage.CoveredLines + coverage.NotCoveredLines,
		})

		totalCoveredLines += coverage.CoveredLines
		totalNotCoveredLines += coverage.NotCoveredLines
	}

	// Final summary
	totalStatements := totalCoveredLines + totalNotCoveredLines
	var totalCoverage float64
	if totalStatements > 0 {
		totalCoverage = float64(totalCoveredLines) / float64(totalStatements) * 100
	}

	report := JSONReport{
		Modules: moduleCoverages,
		Total:   totalCoverage,
		Errors:  0,
	}

	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", "  ")
	return enc.Encode(report)
}

//
// ---------- Module Name Utility ----------
//

// extractModuleName turns a file path like rego-coverage-foo-bar.json
// into a readable module name like foo/bar
func extractModuleName(filePath string) string {
	base := filepath.Base(filePath)
	name := strings.TrimSuffix(base, filepath.Ext(base))
	name = strings.TrimPrefix(name, "rego-coverage-")
	name = strings.ReplaceAll(name, "-", "/")
	return name
}
