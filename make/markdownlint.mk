# Markdownlint Targets
# Documentation linting and validation

## —— 📝 Markdownlint ——

.PHONY: has-markdownlint
has-markdownlint:
	@command -v markdownlint-cli2 >/dev/null 2>&1 || command -v markdownlint >/dev/null 2>&1

.PHONY: ensure-markdownlint
ensure-markdownlint:
	@if ! command -v markdownlint-cli2 >/dev/null 2>&1 && ! command -v markdownlint >/dev/null 2>&1; then \
		echo "❌ Markdownlint not installed - run: make install-markdownlint"; \
		exit 1; \
	fi

.PHONY: markdownlint
markdownlint: ensure-markdownlint ## Check Markdown files for style issues
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/markdownlint.sh

.PHONY: markdownlint-fix
markdownlint-fix: ensure-markdownlint ## Auto-fix Markdown style issues
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/markdownlint.sh --fix

##
.PHONY: install-markdownlint
install-markdownlint: ## Install markdownlint
	@CI=true bash $(ZAIRAKAI_SCRIPTS_DIR)/install-markdownlint.sh
