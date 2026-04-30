CPM_ENV_FILE = .cpmenv
ifeq (,$(wildcard $(CPM_ENV_FILE)))
$(error Error: $(CPM_ENV_FILE) not found. Run: curl -o .cpmenv https://raw.githubusercontent.com/caylent-solutions/cpm/main/examples/example-make-task-runner/.cpmenv)
endif
include $(CPM_ENV_FILE)

# Validate required variables
REQUIRED_VARS := \
	REPO_MANIFESTS_URL \
	REPO_MANIFESTS_REVISION \
	REPO_MANIFESTS_PATH \
	REPO_URL \
	REPO_REV \
	ASDF_URL \
	ASDF_VERSION \
	ASDF_DIR \
	TOOL_VERSIONS_FILE \
	DEFAULT_PYTHON_VERSION \
	PACKAGES_DIR
$(foreach var,$(REQUIRED_VARS),$(if $($(var)),,$(error Error: $(var) not set in $(CPM_ENV_FILE))))

# Export variables for repo tool
export REPO_URL REPO_REV GITBASE

# Include project level defaults (env vars, etc.)
-include Makefile.includes

# Include all package Makefiles after configuration is loaded
-include $(PACKAGES_DIR)/*/Makefile

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show available make targets
	@echo "Available targets:"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | uniq | \
		grep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: cpm-clean
cpm-clean:
	@rm -rf $(PACKAGES_DIR) .repo
	@echo "Cleaned $(PACKAGES_DIR) and .repo directories"

.PHONY: cpm-configure
cpm-configure: cpm-install-asdf cpm-install-tools cpm-install-repo
	@ASDF_DIR=$(ASDF_DIR) && . $$ASDF_DIR/asdf.sh && \
	if ! which repo > /dev/null 2>&1; then \
		echo "Error: repo tool not found after installation"; \
		exit 1; \
	fi && \
	echo "Using repo version: $(REPO_REV)" && \
	echo n | repo --color=never init --no-repo-verify \
		-u "$(REPO_MANIFESTS_URL)" \
		-b "$(REPO_MANIFESTS_REVISION)" \
		-m "$(REPO_MANIFESTS_PATH)" \
		--repo-rev="$(REPO_REV)" || { echo "Error: repo init failed"; exit 1; } && \
	repo sync || { echo "Error: repo sync failed"; exit 1; }

.PHONY: cpm-install-asdf
cpm-install-asdf:
	@if [ -d "$(ASDF_DIR)" ]; then \
		echo "asdf already installed at $(ASDF_DIR)"; \
	else \
		echo "Installing asdf $(ASDF_VERSION)..."; \
		git clone $(ASDF_URL) $(ASDF_DIR) --branch $(ASDF_VERSION) || { echo "Error: Failed to clone asdf"; exit 1; }; \
		echo "asdf installed successfully"; \
	fi
	@if [ ! -f "$(TOOL_VERSIONS_FILE)" ]; then \
		echo "Creating $(TOOL_VERSIONS_FILE) with python $(DEFAULT_PYTHON_VERSION)..."; \
		echo "python $(DEFAULT_PYTHON_VERSION)" > $(TOOL_VERSIONS_FILE); \
	else \
		if ! grep -q "^python" $(TOOL_VERSIONS_FILE); then \
			echo "Adding python $(DEFAULT_PYTHON_VERSION) to $(TOOL_VERSIONS_FILE)..."; \
			echo "python $(DEFAULT_PYTHON_VERSION)" >> $(TOOL_VERSIONS_FILE); \
		fi; \
	fi

.PHONY: cpm-install-repo
cpm-install-repo:
	@if [ -z "$(REPO_REV)" ]; then \
		echo "Error: REPO_REV not set"; \
		exit 1; \
	fi
	@ASDF_DIR=$(ASDF_DIR) && . $$ASDF_DIR/asdf.sh && \
	echo "Installing repo tool version $(REPO_REV)..." && \
	pip install "git+$(REPO_URL)@$(REPO_REV)" || { echo "Error: Failed to install repo tool"; exit 1; } && \
	asdf reshim python && \
	echo "Repo tool installed successfully"

.PHONY: cpm-install-tools
cpm-install-tools:
	@if [ ! -d "$(ASDF_DIR)" ]; then \
		echo "Error: asdf not installed. Run 'make cpm-install-asdf' first."; \
		exit 1; \
	fi
	@if [ ! -f "$(TOOL_VERSIONS_FILE)" ]; then \
		echo "Error: $(TOOL_VERSIONS_FILE) not found. Run 'make cpm-install-asdf' first."; \
		exit 1; \
	fi
	@ASDF_DIR=$(ASDF_DIR) && . $$ASDF_DIR/asdf.sh && \
	awk '{print $$1}' $(TOOL_VERSIONS_FILE) | sort -u | while read plugin; do \
		if ! asdf plugin list | grep -q "^$$plugin$$"; then \
			echo "Installing asdf plugin: $$plugin"; \
			asdf plugin add $$plugin || { echo "Error: Failed to add plugin $$plugin"; exit 1; }; \
		fi; \
	done && \
	echo "Installing tools from $(TOOL_VERSIONS_FILE)..." && \
	asdf install || { echo "Error: Failed to install tools"; exit 1; } && \
	echo "Tools installed successfully"
