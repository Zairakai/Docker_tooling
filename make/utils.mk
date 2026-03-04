# Utility Targets
# Miscellaneous development commands

## —— 🛠️  Utilities ——

.PHONY: git-submodules
git-submodules: ## Install-Update submodules
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/git-submodules.sh

.PHONY: git-update
git-update: ## Fast-forward all local branches tracking a remote
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/git-update.sh

.PHONY: git-cleanup
git-cleanup: ## Remove local branches whose remote tracking branch no longer exists
	@bash $(ZAIRAKAI_SCRIPTS_DIR)/git-cleanup.sh
