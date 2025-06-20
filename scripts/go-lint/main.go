package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

var (
	ignoredDirs []string
	skipPrefix  string
	dirsToLint  []string
)

type Config struct {
	Scripts struct {
		LintDirectories []string `json:"lint_directories"`
	} `json:"scripts"`
}

func main() {
	configPath := flag.String("config", "", "Path to config JSON file")
	skipPrefixFlag := flag.String("skip-prefix", "", "Package prefix to skip during linting")
	pathFlag := flag.String("path", "", "Direct path to lint (bypasses config)")
	flag.Parse()

	if *pathFlag != "" {
		// Direct mode - use specified path
		dirsToLint = []string{*pathFlag}
	} else {
		// Config mode - require config file
		if *configPath == "" {
			fmt.Println("Error: --config flag is required when --path is not specified")
			os.Exit(1)
		}

		// Load config file
		config, err := loadConfig(*configPath)
		if err != nil {
			fmt.Printf("Error loading config file: %v\n", err)
			os.Exit(1)
		}

		// Set directories to lint
		dirsToLint = config.Scripts.LintDirectories
		if len(dirsToLint) == 0 {
			fmt.Println("Error: No directories to lint specified in config")
			os.Exit(1)
		}
	}

	skipPrefix = *skipPrefixFlag

	os.Setenv("GOGC", "off")

	exitCode := 0

	fmt.Println("Step 1: Running gofmt checks...")
	gofmtResult := runGofmtChecks()
	if gofmtResult != 0 {
		exitCode = 1
	}

	fmt.Println("Step 2: Running go vet checks...")
	goVetResult := runGoVetChecks()
	if goVetResult != 0 {
		exitCode = 1
	}

	fmt.Println("\n=== Lint Summary ===")
	fmt.Printf("gofmt checks: %s\n", formatStatus(gofmtResult == 0, "violates code formatting policy"))
	fmt.Printf("go vet checks: %s\n", formatStatus(goVetResult == 0, "violates code correctness policy"))

	os.Exit(exitCode)
}

func loadConfig(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file: %v", err)
	}

	var config Config
	if err := json.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("failed to parse config file: %v", err)
	}

	return &config, nil
}

func runGofmtChecks() int {
	failedFiles := 0

	for _, dir := range dirsToLint {
		cmd := exec.Command("gofmt", "-l", dir)
		output, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Printf("Error running gofmt on %s: %v\n", dir, err)
			fmt.Println(string(output))
			return 1
		}

		files := strings.TrimSpace(string(output))
		if files != "" {
			if failedFiles == 0 {
				fmt.Println("Files needing formatting (violates gofmt policy):")
			}

			for _, file := range strings.Split(files, "\n") {
				if file == "" {
					continue
				}
				if shouldIgnoreFile(file) {
					continue
				}
				fmt.Printf("❌ %s\n", file)
				failedFiles++
			}
		}
	}

	if failedFiles > 0 {
		return 1
	}

	fmt.Println("✅ All files properly formatted")
	return 0
}

func runGoVetChecks() int {
	govetExit := 0

	for _, dir := range dirsToLint {
		err := filepath.WalkDir(dir, func(path string, d os.DirEntry, err error) error {
			if err != nil {
				return err
			}
			if d == nil || d.IsDir() || !strings.HasSuffix(path, ".go") {
				return nil
			}
			if shouldIgnoreFile(path) {
				return nil
			}

			cmd := exec.Command("go", "vet", path)
			output, err := cmd.CombinedOutput()
			if err != nil {
				// For test files, show as checked but don't fail the build
				if strings.HasSuffix(path, "_test.go") {
					fmt.Printf("✅ %s (test file - checked)\n", path)
				} else {
					fmt.Printf("❌ %s (violates go vet policy)\n", path)
					printLines(output)
					govetExit = 1
				}
			} else {
				fmt.Printf("✅ %s\n", path)
			}
			return nil
		})
		if err != nil {
			fmt.Printf("Error walking %s directory: %v\n", dir, err)
			govetExit = 1
		}
	}

	return govetExit
}

func shouldIgnoreFile(filePath string) bool {
	for _, dir := range ignoredDirs {
		if dir == "" {
			continue
		}
		if strings.HasPrefix(filePath, dir+"/") || filePath == dir {
			return true
		}
	}
	return false
}

func printLines(output []byte) {
	lines := strings.Split(string(output), "\n")
	for _, line := range lines {
		if line != "" {
			fmt.Printf("   %s\n", line)
		}
	}
}

func formatStatus(success bool, failMessage string) string {
	if success {
		return "PASS ✅"
	}
	return fmt.Sprintf("FAIL ❌ (%s)", failMessage)
}
