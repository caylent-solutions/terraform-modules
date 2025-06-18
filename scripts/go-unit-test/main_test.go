package main

import (
	"testing"
)

// TestExtractCoveragePercentage tests the extractCoveragePercentage function
func TestExtractCoveragePercentage(t *testing.T) {
	tests := []struct {
		name     string
		output   string
		expected string
	}{
		{
			name:     "normal output",
			output:   "ok  \tpackage/path\t0.006s\ncoverage: 75.0% of statements",
			expected: "75.0%",
		},
		{
			name:     "no coverage",
			output:   "ok  \tpackage/path\t0.006s",
			expected: "0.0%",
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			result := extractCoveragePercentage(test.output)
			if result != test.expected {
				t.Errorf("Expected %s, got %s", test.expected, result)
			}
		})
	}
}

// TestParseCoveragePercentage tests the parseCoveragePercentage function
func TestParseCoveragePercentage(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected float64
	}{
		{
			name:     "valid percentage",
			input:    "75.0%",
			expected: 75.0,
		},
		{
			name:     "zero percentage",
			input:    "0.0%",
			expected: 0.0,
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			result := parseCoveragePercentage(test.input)
			if result != test.expected {
				t.Errorf("Expected %f, got %f", test.expected, result)
			}
		})
	}
}

// TestExtractStatementCount tests the extractStatementCount function
func TestExtractStatementCount(t *testing.T) {
	tests := []struct {
		name     string
		output   string
		expected int
	}{
		{
			name:     "normal output",
			output:   "ok  \tpackage/path\t0.006s\ncoverage: 75.0% of 200 statements",
			expected: 200,
		},
		{
			name:     "no statement count",
			output:   "ok  \tpackage/path\t0.006s\ncoverage: 75.0%",
			expected: 0,
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			result := extractStatementCount(test.output)
			if result != test.expected {
				t.Errorf("Expected %d, got %d", test.expected, result)
			}
		})
	}
}

// TestFileExists tests the fileExists function
func TestFileExists(t *testing.T) {
	// Test with a file that should exist
	if !fileExists("/bin/bash") {
		t.Errorf("Expected /bin/bash to exist")
	}

	// Test with a file that should not exist
	if fileExists("/this/file/does/not/exist") {
		t.Errorf("Expected /this/file/does/not/exist to not exist")
	}
}
