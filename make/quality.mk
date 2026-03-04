# Quality Targets
# Aggregates available quality checks based on installed tools

## —— ✅ Quality Gates ——

# Collect available quality checks
QUALITY_CHECKS :=
ifneq ($(shell command -v markdownlint-cli2 2>/dev/null || command -v markdownlint 2>/dev/null),)
    QUALITY_CHECKS += markdownlint
endif
ifneq ($(shell command -v shellcheck 2>/dev/null),)
    QUALITY_CHECKS += shellcheck
endif
ifneq ($(shell command -v hadolint 2>/dev/null),)
    QUALITY_CHECKS += hadolint
endif

.PHONY: quality
quality: $(QUALITY_CHECKS) ## Run all available quality checks
	@if [ -z "$(QUALITY_CHECKS)" ]; then \
		echo "⚠️  No quality tools installed"; \
		echo "   Run: make install-tools"; \
		exit 1; \
	fi
	@echo ""
	@echo "✅ All quality checks passed"

.PHONY: ci-full
ci-full: quality ## Complete validation (quality + optional tests)
	@if command -v bats >/dev/null 2>&1 && [ -d "tests" ]; then \
		echo ""; \
		echo "→ Running tests..."; \
		$(MAKE) bats; \
	fi
	@echo ""
	@echo "✅ Full validation passed"
