# Hadolint Targets
# Dockerfile linting and best practices validation

## —— 🐳 Hadolint ——

.PHONY: has-hadolint
has-hadolint:
	@command -v hadolint >/dev/null 2>&1

.PHONY: ensure-hadolint
ensure-hadolint:
	@if ! command -v hadolint >/dev/null 2>&1; then \
		echo "❌ Hadolint not installed - run: make install-hadolint"; \
		exit 1; \
	fi

.PHONY: hadolint
hadolint: ensure-hadolint ## Validate Dockerfile
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/hadolint.sh

##
.PHONY: install-hadolint
install-hadolint: ## Install Hadolint
	@CI=true bash $(ZAIRAKAI_SCRIPTS_DIR)/install-hadolint.sh
