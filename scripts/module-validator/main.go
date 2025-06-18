package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// Colors for terminal output
const (
	ColorReset  = "\033[0m"
	ColorRed    = "\033[31m"
	ColorGreen  = "\033[32m"
	ColorYellow = "\033[33m"
	ColorBlue   = "\033[34m"
	ColorCyan   = "\033[36m"
	ColorGray   = "\033[90m"
)

// Debug levels
const (
	LevelError = iota
	LevelWarn
	LevelInfo
	LevelDebug
	LevelTrace
)

var debugLevel = LevelInfo // Default debug level

// logMessage logs a message at the specified level
func logMessage(level int, format string, args ...interface{}) {
	if level > debugLevel {
		return
	}

	var prefix string
	switch level {
	case LevelError:
		prefix = fmt.Sprintf("%sERROR%s", ColorRed, ColorReset)
	case LevelWarn:
		prefix = fmt.Sprintf("%sWARN%s", ColorYellow, ColorReset)
	case LevelInfo:
		prefix = fmt.Sprintf("%sINFO%s", ColorBlue, ColorReset)
	case LevelDebug:
		prefix = fmt.Sprintf("%sDEBUG%s", ColorCyan, ColorReset)
	case LevelTrace:
		prefix = fmt.Sprintf("%sTRACE%s", ColorGray, ColorReset)
	}

	fmt.Printf("%s: %s\n", prefix, fmt.Sprintf(format, args...))
}

func main() {
	modulePath := flag.String("module-path", "", "Path to the Terraform module")
	moduleType := flag.String("module-type", "", "Type of the Terraform module (utility, collection, reference, etc.)")
	configPath := flag.String("config", "", "Path to the monorepo configuration file")
	verbose := flag.Bool("verbose", false, "Enable verbose output")
	flag.Parse()

	// Set debug level based on verbose flag
	if *verbose {
		debugLevel = LevelDebug
		fmt.Println("Verbose mode enabled")
	}

	if *modulePath == "" {
		logMessage(LevelError, "Module path is required")
		os.Exit(1)
	}

	if *moduleType == "" {
		logMessage(LevelError, "Module type is required")
		os.Exit(1)
	}

	if *configPath == "" {
		logMessage(LevelError, "Config path is required")
		os.Exit(1)
	}

	logMessage(LevelInfo, "Starting module validation for %s module at %s", *moduleType, *modulePath)

	// Load configuration
	config, err := loadConfig(*configPath)
	if err != nil {
		logMessage(LevelError, "Error loading configuration: %v", err)
		os.Exit(1)
	}
	logMessage(LevelDebug, "Configuration loaded from %s", *configPath)

	// Get scripts configuration
	scripts, ok := config["scripts"].(map[string]interface{})
	if !ok {
		logMessage(LevelError, "Scripts configuration not found")
		os.Exit(1)
	}

	// Get temp file pattern
	tempFilePattern, ok := scripts["temp_file_pattern"].(string)
	if !ok {
		tempFilePattern = "terraform-files-*.json" // Fallback
		logMessage(LevelWarn, "Temp file pattern not found in config, using default: %s", tempFilePattern)
	} else {
		logMessage(LevelDebug, "Using temp file pattern: %s", tempFilePattern)
	}

	// Get terraform file collector script
	tfCollectorScript, ok := scripts["terraform_file_collector"].(string)
	if !ok {
		logMessage(LevelError, "terraform_file_collector script not found in config")
		os.Exit(1)
	}
	logMessage(LevelDebug, "Using terraform file collector script: %s", tfCollectorScript)

	// Create temporary file for Terraform files
	tempFile, err := ioutil.TempFile("", tempFilePattern)
	if err != nil {
		logMessage(LevelError, "Error creating temporary file: %v", err)
		os.Exit(1)
	}
	defer os.Remove(tempFile.Name())
	tempFile.Close()
	logMessage(LevelDebug, "Created temporary file: %s", tempFile.Name())

	// Collect Terraform files
	var cmd *exec.Cmd
	var scriptPath string

	// Check if the collector script is a relative path or just a name
	if strings.HasPrefix(tfCollectorScript, "./") || strings.HasPrefix(tfCollectorScript, "/") {
		// It's a path, use it directly
		scriptPath = tfCollectorScript
	} else {
		// It's just a name, assume it's in the scripts directory
		scriptPath = filepath.Join("./scripts", tfCollectorScript, "main.go")
	}

	logMessage(LevelDebug, "Running terraform file collector: %s", scriptPath)
	logMessage(LevelDebug, "Module path: %s", *modulePath)
	logMessage(LevelDebug, "Output file: %s", tempFile.Name())
	logMessage(LevelDebug, "Config path: %s", *configPath)

	cmd = exec.Command("go", "run", scriptPath,
		"--module-path", *modulePath,
		"--output", tempFile.Name(),
		"--config", *configPath)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		logMessage(LevelError, "Error collecting Terraform files: %v", err)
		os.Exit(1)
	}
	logMessage(LevelInfo, "Terraform files collected successfully")

	// Determine policy directories to evaluate
	var policyDirs []string

	// Get module type specific policy directory
	moduleTypes, ok := config["module_types"].(map[string]interface{})
	if !ok {
		logMessage(LevelError, "module_types not found in config")
		os.Exit(1)
	}

	typeConfig, ok := moduleTypes[*moduleType].(map[string]interface{})
	if !ok {
		logMessage(LevelWarn, "No specific policies for module type: %s", *moduleType)
	} else {
		policyDir, ok := typeConfig["policy_dir"].(string)
		if ok {
			policyDirs = append(policyDirs, policyDir)
			logMessage(LevelInfo, "Added module type specific policy directory: %s", policyDir)
		} else {
			logMessage(LevelWarn, "No policy directory defined for module type: %s", *moduleType)
		}
	}

	// Get additional policy directories from config
	additionalPolicyDirs, ok := config["module_validator_additional_policies"].([]interface{})
	if ok {
		logMessage(LevelDebug, "Found additional policy directories configuration")
		for _, dirKey := range additionalPolicyDirs {
			if dirKeyStr, ok := dirKey.(string); ok {
				// Look up the policy directory in rego_policy_dirs
				regoPolicyDirs, ok := config["rego_policy_dirs"].(map[string]interface{})
				if ok {
					if policyDir, ok := regoPolicyDirs[dirKeyStr].(string); ok {
						policyDirs = append(policyDirs, policyDir)
						logMessage(LevelInfo, "Added additional policy directory: %s", policyDir)
					} else {
						logMessage(LevelWarn, "Policy directory not found for key: %s", dirKeyStr)
					}
				} else {
					logMessage(LevelWarn, "rego_policy_dirs not found in config")
				}
			}
		}
	} else {
		logMessage(LevelWarn, "No additional policy directories configured")
	}

	if len(policyDirs) == 0 {
		logMessage(LevelWarn, "No policy directories found to evaluate")
		os.Exit(0)
	}
	logMessage(LevelInfo, "Found %d policy directories to evaluate", len(policyDirs))

	// Run OPA evaluation
	fmt.Printf("\n%s=== Evaluating policies for %s module ===%s\n", ColorBlue, *moduleType, ColorReset)

	// Collect all policy files from all directories
	var allPolicyFiles []string
	for _, dir := range policyDirs {
		logMessage(LevelInfo, "Looking for policies in: %s", dir)
		policyFiles, err := filepath.Glob(filepath.Join(dir, "*.rego"))
		if err != nil {
			logMessage(LevelError, "Error finding policy files in %s: %v", dir, err)
			continue
		}
		logMessage(LevelDebug, "Found %d policy files in %s", len(policyFiles), dir)
		for _, file := range policyFiles {
			logMessage(LevelTrace, "Found policy file: %s", file)
		}
		allPolicyFiles = append(allPolicyFiles, policyFiles...)
	}

	if len(allPolicyFiles) == 0 {
		logMessage(LevelWarn, "No policy files found in any policy directories")
		os.Exit(0)
	}
	logMessage(LevelInfo, "Found %d total policy files to evaluate", len(allPolicyFiles))

	// Prepare for evaluation
	violations := false
	policyFileResults := make(map[string]bool) // Track pass/fail for each policy file
	policyFileErrors := make(map[string]bool)  // Track execution errors for each policy file

	// Track individual rules
	type RuleResult struct {
		PolicyFile string
		RuleName   string
		Passed     bool
		HasError   bool
		Violations int
	}
	var allRuleResults []RuleResult

	// Evaluate each policy file
	for i, policyFile := range allPolicyFiles {
		policyName := filepath.Base(policyFile)

		if i > 0 {
			// Only add a blank line between policies
			fmt.Printf("\n\n")
		} else {
			// For the first policy, just add a blank line
			fmt.Printf("\n")
		}

		fmt.Printf("\n%s🔍 Evaluating policy:%s %s\n", ColorBlue, ColorReset, policyName)

		// Determine package name from policy file
		packageName := getPackageName(policyFile)
		if packageName == "" {
			fmt.Printf("%sError: Could not determine package name for %s%s\n", ColorRed, policyFile, ColorReset)
			violations = true
			policyFileErrors[policyName] = true
			continue
		}

		// Modify the input data to include the module_path
		inputData, err := ioutil.ReadFile(tempFile.Name())
		if err != nil {
			logMessage(LevelError, "Error reading input file: %v", err)
			violations = true
			policyFileErrors[policyName] = true
			continue
		}

		var inputJSON map[string]interface{}
		if err := json.Unmarshal(inputData, &inputJSON); err != nil {
			logMessage(LevelError, "Error parsing input JSON: %v", err)
			violations = true
			policyFileErrors[policyName] = true
			continue
		}

		// Process module paths
		cleanModulePath := strings.TrimSuffix(*modulePath, "/")
		moduleName := filepath.Base(cleanModulePath)

		// Add both paths to the input JSON
		inputJSON["module_path"] = moduleName    // Just the module name for policy evaluation
		inputJSON["repo_path"] = cleanModulePath // Full path for display

		logMessage(LevelDebug, "Git repo path: %s", cleanModulePath)
		logMessage(LevelDebug, "Testing module: %s", moduleName)

		// Transform file paths to use module name as root
		if files, ok := inputJSON["files"].(map[string]interface{}); ok {
			transformedFiles := make(map[string]interface{})
			for filePath, content := range files {
				// If the file path starts with the repo path, replace it with the module name
				if strings.HasPrefix(filePath, cleanModulePath+"/") {
					newPath := strings.Replace(filePath, cleanModulePath, moduleName, 1)
					transformedFiles[newPath] = content
				} else {
					transformedFiles[filePath] = content
				}
			}
			inputJSON["files"] = transformedFiles
		}

		// Log files found by the collector
		if files, ok := inputJSON["files"].(map[string]interface{}); ok {
			logMessage(LevelDebug, "Found %d files in the module", len(files))
			for filePath := range files {
				logMessage(LevelTrace, "File: %s", filePath)
			}
		}

		// Write the modified input back to a temporary file
		modifiedInputFile, err := ioutil.TempFile("", "modified-input-*.json")
		if err != nil {
			logMessage(LevelError, "Error creating modified input file: %v", err)
			violations = true
			policyFileErrors[policyName] = true
			continue
		}
		defer os.Remove(modifiedInputFile.Name())
		logMessage(LevelDebug, "Created modified input file: %s", modifiedInputFile.Name())

		modifiedInputData, err := json.MarshalIndent(inputJSON, "", "  ")
		if err != nil {
			logMessage(LevelError, "Error marshaling modified input: %v", err)
			violations = true
			policyFileErrors[policyName] = true
			continue
		}

		if err := ioutil.WriteFile(modifiedInputFile.Name(), modifiedInputData, 0644); err != nil {
			logMessage(LevelError, "Error writing modified input: %v", err)
			violations = true
			policyFileErrors[policyName] = true
			continue
		}
		logMessage(LevelTrace, "Modified input JSON:\n%s", string(modifiedInputData))

		// First, discover all rules in the policy file
		listRulesArgs := []string{
			"eval",
			"--format", "json",
			"--data", policyFile,
			"data." + packageName,
			"--input", modifiedInputFile.Name(),
		}

		cmd := exec.Command("opa", listRulesArgs...)
		rulesOutput, _ := cmd.CombinedOutput()

		// Default to just "violation" if we can't determine rules
		rules := []string{"violation"}

		// Try to parse the rules output
		var rulesResult map[string]interface{}
		if err := json.Unmarshal(rulesOutput, &rulesResult); err == nil {
			if result, ok := rulesResult["result"].(map[string]interface{}); ok {
				// Extract rule names
				ruleNames := []string{}
				for ruleName := range result {
					if ruleName != "debug_info" && !strings.HasPrefix(ruleName, "__") {
						ruleNames = append(ruleNames, ruleName)
					}
				}
				if len(ruleNames) > 0 {
					rules = ruleNames
				}
			}
		}

		// Track policy file results
		policyFileHasViolations := false
		policyFileHasErrors := false

		// Evaluate each rule
		for _, rule := range rules {
			// Skip non-violation rules
			if rule != "violation" && !strings.HasSuffix(rule, "violation") {
				continue
			}

			ruleName := rule
			if rule == "violation" {
				ruleName = "main"
			}

			// Run OPA evaluation for this rule
			opaArgs := []string{
				"eval",
				"--format", "json",
				"--data", policyFile,
				"data." + packageName + "." + rule,
				"--input", modifiedInputFile.Name(),
			}

			logMessage(LevelDebug, "Running OPA with args: %v", opaArgs)
			cmd := exec.Command("opa", opaArgs...)
			output, err := cmd.CombinedOutput()

			// Only show OPA output in trace mode (more detailed than debug)
			logMessage(LevelTrace, "OPA output for rule %s: %s", ruleName, string(output))

			ruleResult := RuleResult{
				PolicyFile: policyName,
				RuleName:   ruleName,
				Passed:     true,
				HasError:   false,
				Violations: 0,
			}

			if err != nil {
				logMessage(LevelError, "Error evaluating rule %s in policy %s: %v", ruleName, policyName, err)
				logMessage(LevelError, "OPA output: %s", string(output))
				violations = true
				policyFileHasErrors = true
				ruleResult.HasError = true
				ruleResult.Passed = false
				allRuleResults = append(allRuleResults, ruleResult)
				continue
			}

			// Parse results
			var result map[string]interface{}
			if err := json.Unmarshal(output, &result); err != nil {
				logMessage(LevelError, "Error parsing rule results: %v", err)
				policyFileHasErrors = true
				ruleResult.HasError = true
				ruleResult.Passed = false
				allRuleResults = append(allRuleResults, ruleResult)
				violations = true
				continue
			}

			// Check for violations
			if results, ok := result["result"].([]interface{}); ok && len(results) > 0 {
				// Check if the result is actually empty (which means a pass)
				hasViolations := false

				for _, r := range results {
					logMessage(LevelDebug, "Processing result: %T, Keys: %v", r, func() []string {
						if m, ok := r.(map[string]interface{}); ok {
							keys := make([]string, 0, len(m))
							for k := range m {
								keys = append(keys, k)
							}
							return keys
						}
						return nil
					}())

					if rMap, ok := r.(map[string]interface{}); ok {
						// Check for expressions structure first (OPA eval format)
						if expressions, ok := rMap["expressions"].([]interface{}); ok {
							logMessage(LevelDebug, "Found expressions field with %d expressions", len(expressions))
							for _, expr := range expressions {
								if exprMap, ok := expr.(map[string]interface{}); ok {
									if value, vok := exprMap["value"]; vok {
										logMessage(LevelDebug, "Found value in expression: %T", value)
										// Check for non-empty maps of any type
										switch v := value.(type) {
										case map[string]interface{}:
											logMessage(LevelDebug, "Value is map[string]interface{} with %d keys", len(v))
											if len(v) > 0 {
												hasViolations = true
											}
										case map[string]bool:
											logMessage(LevelDebug, "Value is map[string]bool with %d keys", len(v))
											if len(v) > 0 {
												hasViolations = true
											}
										case map[string]string:
											logMessage(LevelDebug, "Value is map[string]string with %d keys", len(v))
											if len(v) > 0 {
												hasViolations = true
											}
										case []interface{}:
											logMessage(LevelDebug, "Value is []interface{} with %d elements", len(v))
											if len(v) > 0 {
												hasViolations = true
											}
										}
										if hasViolations {
											logMessage(LevelDebug, "hasViolations set to true, breaking")
											break
										}
									}
								}
								if hasViolations {
									break
								}
							}
						} else if value, ok := rMap["value"].(map[string]interface{}); ok && len(value) > 0 {
							// Check for direct value field (direct violation format)
							logMessage(LevelDebug, "Found violation in direct value field")
							hasViolations = true
						}
					}
					if hasViolations {
						break
					}
				}

				if hasViolations {
					violations = true
					policyFileHasViolations = true
					ruleResult.Passed = false

					// Count violations
					violationCount := 0
					for _, r := range results {
						if violation, ok := r.(map[string]interface{}); ok {
							if value, ok := violation["value"].(map[string]interface{}); ok {
								violationCount += len(value)
							} else {
								violationCount++
							}
						} else if expressions, ok := r.(map[string]interface{})["expressions"].([]interface{}); ok {
							for _, expr := range expressions {
								if exprMap, ok := expr.(map[string]interface{}); ok {
									if value, vok := exprMap["value"]; vok {
										// Count violations from different map types
										switch v := value.(type) {
										case map[string]interface{}:
											violationCount += len(v)
										case map[string]bool:
											violationCount += len(v)
										case map[string]string:
											violationCount += len(v)
										case []interface{}:
											violationCount += len(v)
										default:
											if violationCount == 0 {
												violationCount = 1
											}
										}
									}
								}
							}
							if violationCount == 0 {
								violationCount = 1 // At least one violation
							}
						} else {
							violationCount++
						}
					}
					ruleResult.Violations = violationCount

					fmt.Printf("  %s❌ FAIL: %s.%s%s\n", ColorRed, policyName, ruleName, ColorReset)
				} else {
					// Empty result means pass
					fmt.Printf("  %s✅ PASS: %s.%s%s\n", ColorGreen, policyName, ruleName, ColorReset)
				}

				// Log the raw result structure
				resultBytes, _ := json.MarshalIndent(result, "", "  ")
				logMessage(LevelDebug, "Raw result: %s", string(resultBytes))

				// Only log "Violation detected" if there are actual violations
				if hasViolations {
					logMessage(LevelDebug, "Violation detected")
				}

				for _, r := range results {
					// Log the type and content of each result
					logMessage(LevelDebug, "Result type: %T, Value: %v", r, r)

					if violation, ok := r.(map[string]interface{}); ok {
						// Check if the violation has the expected fields
						if message, ok := violation["message"]; ok && message != nil {
							fmt.Printf("    %s%v%s\n", ColorRed, message, ColorReset)
						} else {
							// Check for expressions field which might contain the violation
							hasViolationData := false
							if expressions, ok := r.(map[string]interface{})["expressions"].([]interface{}); ok && len(expressions) > 0 {
								if expr, ok := expressions[0].(map[string]interface{}); ok {
									// Check for non-empty map or non-empty array
									if value, vok := expr["value"]; vok {
										switch v := value.(type) {
										case map[string]interface{}:
											if len(v) > 0 {
												hasViolationData = true
												// Try to parse JSON-encoded keys for violation details
												for k := range v {
													var violationDetails map[string]interface{}
													if err := json.Unmarshal([]byte(k), &violationDetails); err == nil {
														if msg, ok := violationDetails["message"]; ok {
															fmt.Printf("    %s%v%s\n", ColorRed, msg, ColorReset)
															if details, ok := violationDetails["details"]; ok {
																fmt.Printf("    Details: %v\n", details)
															}
															if resolution, ok := violationDetails["resolution"]; ok {
																fmt.Printf("    Resolution: %v\n", resolution)
															}
															continue
														}
													}
													// If not JSON, print the key as-is
													fmt.Printf("    %s%s%s\n", ColorRed, k, ColorReset)
												}
											}
										case map[string]bool:
											if len(v) > 0 {
												hasViolationData = true
												// Try to parse JSON-encoded keys for violation details
												for k := range v {
													var violationDetails map[string]interface{}
													if err := json.Unmarshal([]byte(k), &violationDetails); err == nil {
														if msg, ok := violationDetails["message"]; ok {
															fmt.Printf("    %s%v%s\n", ColorRed, msg, ColorReset)
															if details, ok := violationDetails["details"]; ok {
																fmt.Printf("    Details: %v\n", details)
															}
															if resolution, ok := violationDetails["resolution"]; ok {
																fmt.Printf("    Resolution: %v\n", resolution)
															}
															continue
														}
													}
													// If not JSON, print the key as-is
													fmt.Printf("    %s%s%s\n", ColorRed, k, ColorReset)
												}
											}
										case map[string]string:
											if len(v) > 0 {
												hasViolationData = true
												// Try to parse JSON-encoded keys for violation details
												for k := range v {
													var violationDetails map[string]interface{}
													if err := json.Unmarshal([]byte(k), &violationDetails); err == nil {
														if msg, ok := violationDetails["message"]; ok {
															fmt.Printf("    %s%v%s\n", ColorRed, msg, ColorReset)
															if details, ok := violationDetails["details"]; ok {
																fmt.Printf("    Details: %v\n", details)
															}
															if resolution, ok := violationDetails["resolution"]; ok {
																fmt.Printf("    Resolution: %v\n", resolution)
															}
															continue
														}
													}
													// If not JSON, print the key as-is
													fmt.Printf("    %s%s%s\n", ColorRed, k, ColorReset)
												}
											}
										case []interface{}:
											if len(v) > 0 {
												hasViolationData = true
											}
										}
									}
								}
							}
							// Only print generic violation message if no specific violation details were found
							if hasViolations && hasViolationData {
								// Check if we already printed specific violation details above
								needsGenericMessage := true
								if expressions, ok := r.(map[string]interface{})["expressions"].([]interface{}); ok && len(expressions) > 0 {
									if expr, ok := expressions[0].(map[string]interface{}); ok {
										if value, vok := expr["value"]; vok {
											switch value.(type) {
											case map[string]interface{}, map[string]bool, map[string]string:
												needsGenericMessage = false // We already printed specific details above
											}
										}
									}
								}
								if needsGenericMessage {
									fmt.Printf("    %sViolation detected%s\n", ColorRed, ColorReset)
								}
							}
						}

						if details, ok := violation["details"]; ok && details != nil {
							fmt.Printf("    Details: %v\n", details)
						}

						if resolution, ok := violation["resolution"]; ok && resolution != nil {
							fmt.Printf("    Resolution: %v\n", resolution)
						}
					} else if str, ok := r.(string); ok {
						// Handle string violations
						fmt.Printf("    %s%s%s\n", ColorRed, str, ColorReset)
					} else {
						// Handle other types of violations
						fmt.Printf("    %sViolation detected%s\n", ColorRed, ColorReset)
					}
				}
			} else {
				// No results means pass
				fmt.Printf("  %s✅ PASS: %s.%s%s\n", ColorGreen, policyName, ruleName, ColorReset)
			}

			allRuleResults = append(allRuleResults, ruleResult)
		}

		// Update policy file results
		policyFileResults[policyName] = policyFileHasViolations
		policyFileErrors[policyName] = policyFileHasErrors
	}

	// Calculate statistics
	var passedPolicyFiles, failedPolicyFiles, errorPolicyFiles int
	var passedRules, failedRules, errorRules int

	for policyName, hasViolations := range policyFileResults {
		if policyFileErrors[policyName] {
			errorPolicyFiles++
		} else if hasViolations {
			failedPolicyFiles++
		} else {
			passedPolicyFiles++
		}
	}

	for _, result := range allRuleResults {
		if result.HasError {
			errorRules++
		} else if !result.Passed {
			failedRules++
		} else {
			passedRules++
		}
	}

	// Print summary
	fmt.Printf("\n%s=== Module Validation Summary ===%s\n", ColorBlue, ColorReset)
	fmt.Printf("%s✅ Passed:%s %d policy files (%d rules)\n", ColorGreen, ColorReset, passedPolicyFiles, passedRules)
	fmt.Printf("%s❌ Failed:%s %d policy files (%d rules)\n", ColorRed, ColorReset, failedPolicyFiles, failedRules)
	fmt.Printf("%s⚠️ Errors:%s %d policy files (%d rules)\n", ColorYellow, ColorReset, errorPolicyFiles, errorRules)
	fmt.Printf("%s🔍 Total:%s %d policy files (%d rules)\n", ColorCyan, ColorReset, len(allPolicyFiles), len(allRuleResults))

	if violations {
		fmt.Printf("\n%s❌ Module validation FAILED%s\n", ColorRed, ColorReset)
		os.Exit(1)
	} else {
		fmt.Printf("\n%s✅ Module validation PASSED%s\n", ColorGreen, ColorReset)
	}
}

// loadConfig loads the configuration from a JSON file
func loadConfig(path string) (map[string]interface{}, error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file: %w", err)
	}

	var config map[string]interface{}
	if err := json.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("failed to parse config file: %w", err)
	}

	return config, nil
}

// getPackageName extracts the package name from a Rego file
func getPackageName(policyFile string) string {
	data, err := ioutil.ReadFile(policyFile)
	if err != nil {
		return ""
	}

	content := string(data)
	lines := strings.Split(content, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "package ") {
			packageName := strings.TrimPrefix(line, "package ")
			return packageName
		}
	}

	return ""
}
