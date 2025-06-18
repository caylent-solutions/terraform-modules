package main

import (
	"testing"
)

func TestCompareVersions(t *testing.T) {
	tests := []struct {
		name     string
		v1       string
		v2       string
		expected int
	}{
		{"Equal versions", "v1.0.0", "v1.0.0", 0},
		{"Equal versions without v", "1.0.0", "1.0.0", 0},
		{"v1 greater major", "v2.0.0", "v1.0.0", 1},
		{"v1 greater minor", "v1.1.0", "v1.0.0", 1},
		{"v1 greater patch", "v1.0.1", "v1.0.0", 1},
		{"v2 greater major", "v1.0.0", "v2.0.0", -1},
		{"v2 greater minor", "v1.0.0", "v1.1.0", -1},
		{"v2 greater patch", "v1.0.0", "v1.0.1", -1},
		{"v1 longer", "v1.0.0.1", "v1.0.0", 1},
		{"v2 longer", "v1.0.0", "v1.0.0.1", -1},
		{"Mixed v prefix", "v1.0.0", "1.0.0", 0},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := compareVersions(tt.v1, tt.v2)
			if result != tt.expected {
				t.Errorf("compareVersions(%s, %s) = %d, want %d", tt.v1, tt.v2, result, tt.expected)
			}
		})
	}
}
