# ShellCheck Targets
# Shell script validation with 100% compliance requirement

## —— 🐚 ShellCheck ——

.PHONY: has-shellcheck
has-shellcheck:
	@command -v shellcheck >/dev/null 2>&1

.PHONY: ensure-shellcheck
ensure-shellcheck:
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "❌ ShellCheck not installed - run: make install-shellcheck"; \
		exit 1; \
	fi

.PHONY: shellcheck
shellcheck: ensure-shellcheck ## Validate shell scripts (100% compliance required)
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/shellcheck.sh

##
.PHONY: install-shellcheck
install-shellcheck: ## Install ShellCheck
	@CI=true bash $(ZAIRAKAI_SCRIPTS_DIR)/install-shellcheck.sh
