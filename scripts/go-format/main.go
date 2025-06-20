package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

var (
	ignoredDirs  []string
	dirsToFormat []string
)

type Config struct {
	Scripts struct {
		LintDirectories []string `json:"lint_directories"`
	} `json:"scripts"`
}

func main() {
	configPath := flag.String("config", "", "Path to config JSON file")
	pathFlag := flag.String("path", "", "Direct path to format (bypasses config)")
	flag.Parse()

	if *pathFlag != "" {
		// Direct mode - use specified path
		dirsToFormat = []string{*pathFlag}
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

		// Set directories to format
		dirsToFormat = config.Scripts.LintDirectories
		if len(dirsToFormat) == 0 {
			fmt.Println("Error: No directories to format specified in config")
			os.Exit(1)
		}
	}

	os.Setenv("GOGC", "off")

	fmt.Println("Formatting Go code...")
	fixGoFormatting()
}

func fixGoFormatting() {
	filesFixed := 0
	exitCode := 0

	for _, dir := range dirsToFormat {
		// Find files that need formatting in this directory
		cmd := exec.Command("gofmt", "-l", dir)
		output, err := cmd.Output()
		if err != nil {
			fmt.Printf("Error running gofmt on %s: %v\n", dir, err)
			os.Exit(1)
		}

		files := strings.TrimSpace(string(output))
		if files == "" {
			fmt.Printf("✅ All files in %s already properly formatted\n", dir)
			continue
		}

		// Format each file that needs it
		for _, file := range strings.Split(files, "\n") {
			if file == "" {
				continue
			}
			if shouldIgnoreFile(file) {
				continue
			}

			// Format the file
			cmd := exec.Command("gofmt", "-w", file)
			_, err := cmd.CombinedOutput()
			if err != nil {
				fmt.Printf("❌ Error formatting %s: %v\n", file, err)
				exitCode = 1
				continue
			}

			fmt.Printf("Fixed: %s\n", file)
			filesFixed++
		}
	}

	if filesFixed > 0 {
		fmt.Printf("\n✅ Formatting complete: fixed %d file(s)\n", filesFixed)
	} else {
		fmt.Println("\n✅ No files needed formatting")
	}

	if exitCode != 0 {
		os.Exit(exitCode)
	}
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
