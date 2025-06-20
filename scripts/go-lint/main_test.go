package main

import (
	"testing"
)

func TestShouldIgnoreFile(t *testing.T) {
	// Setup test cases
	tests := []struct {
		name       string
		filePath   string
		ignoreDirs []string
		expected   bool
	}{
		{
			name:       "No ignored dirs",
			filePath:   "scripts/lint/main.go",
			ignoreDirs: []string{},
			expected:   false,
		},
		{
			name:       "File in ignored dir",
			filePath:   "bin/something.go",
			ignoreDirs: []string{"bin"},
			expected:   true,
		},
		{
			name:       "File in subdirectory of ignored dir",
			filePath:   "bin/subdir/something.go",
			ignoreDirs: []string{"bin"},
			expected:   true,
		},
		{
			name:       "File not in ignored dir",
			filePath:   "scripts/lint/main.go",
			ignoreDirs: []string{"bin"},
			expected:   false,
		},
		{
			name:       "Multiple ignored dirs, file in first",
			filePath:   "bin/something.go",
			ignoreDirs: []string{"bin", "vendor"},
			expected:   true,
		},
		{
			name:       "Multiple ignored dirs, file in second",
			filePath:   "vendor/something.go",
			ignoreDirs: []string{"bin", "vendor"},
			expected:   true,
		},
		{
			name:       "Empty ignored dir",
			filePath:   "scripts/lint/main.go",
			ignoreDirs: []string{""},
			expected:   false,
		},
	}

	// Run tests
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Set up the global variable used by the function
			ignoredDirs = tt.ignoreDirs

			// Call the function
			result := shouldIgnoreFile(tt.filePath)

			// Check the result
			if result != tt.expected {
				t.Errorf("shouldIgnoreFile(%q) = %v, want %v", tt.filePath, result, tt.expected)
			}
		})
	}
}

func TestFormatStatus(t *testing.T) {
	tests := []struct {
		name        string
		success     bool
		failMessage string
		expected    string
	}{
		{
			name:        "Success",
			success:     true,
			failMessage: "should not be used",
			expected:    "PASS ✅",
		},
		{
			name:        "Failure",
			success:     false,
			failMessage: "test failed",
			expected:    "FAIL ❌ (test failed)",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := formatStatus(tt.success, tt.failMessage)
			if result != tt.expected {
				t.Errorf("formatStatus(%v, %q) = %q, want %q", tt.success, tt.failMessage, result, tt.expected)
			}
		})
	}
}

func TestPrintLines(t *testing.T) {
	// This is a simple test to ensure the function doesn't crash
	// We can't easily test the output since it prints to stdout
	printLines([]byte("line1\nline2\n"))
}
