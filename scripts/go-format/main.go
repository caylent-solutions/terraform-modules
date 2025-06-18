package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

var (
	ignoredDirs []string
)

func main() {
	ignoreFlag := flag.String("ignore", "", "Comma-separated list of directories to ignore during formatting")
	flag.Parse()

	if *ignoreFlag != "" {
		ignoredDirs = strings.Split(*ignoreFlag, ",")
		for i, dir := range ignoredDirs {
			ignoredDirs[i] = strings.TrimSpace(dir)
		}
		if len(ignoredDirs) == 1 {
			fmt.Printf("⚠️  Ignoring directory during formatting: %s\n", ignoredDirs[0])
		} else if len(ignoredDirs) > 1 {
			fmt.Printf("⚠️  Ignoring directories during formatting: %s\n", strings.Join(ignoredDirs, ", "))
		}
	}

	loadAsdf()
	os.Setenv("GOGC", "off")

	fmt.Println("Formatting Go code...")
	fixGoFormatting()
}

func fixGoFormatting() {
	// First, find all files that need formatting
	cmd := exec.Command("gofmt", "-l", ".")
	output, err := cmd.Output()
	if err != nil {
		fmt.Printf("Error running gofmt: %v\n", err)
		os.Exit(1)
	}

	files := strings.TrimSpace(string(output))
	if files == "" {
		fmt.Println("✅ All files already properly formatted")
		return
	}

	// Format each file that needs it
	filesFixed := 0
	for _, file := range strings.Split(files, "\n") {
		if shouldIgnoreFile(file) {
			continue
		}

		// Format the file
		cmd := exec.Command("gofmt", "-w", file)
		_, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Printf("❌ Error formatting %s: %v\n", file, err)
			continue
		}

		fmt.Printf("Fixed: %s\n", file)
		filesFixed++
	}

	if filesFixed > 0 {
		fmt.Printf("\n✅ Formatting complete: fixed %d file(s)\n", filesFixed)
	} else {
		fmt.Println("\n✅ No files needed formatting")
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

func loadAsdf() {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return
	}

	asdfPath := filepath.Join(homeDir, ".asdf", "asdf.sh")
	if _, err := os.Stat(asdfPath); os.IsNotExist(err) {
		// asdf not installed, skip loading
		return
	}

	cmd := exec.Command("bash", "-c", fmt.Sprintf(". %s && env", asdfPath))
	output, err := cmd.CombinedOutput()
	if err != nil {
		return
	}

	for _, line := range strings.Split(string(output), "\n") {
		if parts := strings.SplitN(line, "=", 2); len(parts) == 2 {
			os.Setenv(parts[0], parts[1])
		}
	}
}
