# BATS Testing Targets
# Shell script testing with Bash Automated Testing System

## —— 🧪 Shell Script Testing ——

.PHONY: has-bats
has-bats:
	@command -v bats >/dev/null 2>&1

.PHONY: ensure-bats
ensure-bats:
	@if ! command -v bats >/dev/null 2>&1; then \
		echo "❌ BATS not installed - run: make install-bats"; \
		exit 1; \
	fi

.PHONY: bats
bats: bats-unit bats-integration ## Run all BATS tests

.PHONY: bats-unit
bats-unit: ensure-bats ## Run BATS unit tests
	@if [ -d "tests/unit" ]; then \
		bats tests/unit/*.bats; \
	else \
		echo "⚠️  No tests/unit directory found"; \
	fi

.PHONY: bats-integration
bats-integration: ensure-bats ## Run BATS integration tests
	@if [ -d "tests/integration" ]; then \
		bats tests/integration/*.bats; \
	else \
		echo "⚠️  No tests/integration directory found"; \
	fi

##
.PHONY: install-bats
install-bats: ## Install BATS framework
	@CI=true bash $(ZAIRAKAI_SCRIPTS_DIR)/install-bats.sh
