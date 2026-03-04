# Help target

## —— 📚 Help ——

.PHONY: help
help: ## Show available commands
	@echo ""
	@printf "$(COLOR_HEADER_FG)$(COLOR_HEADER_BG)%*s$(COLOR_RESET)\n" $(HELP_WIDTH) ""
	@printf "$(COLOR_HEADER_FG)$(COLOR_HEADER_BG)   %-*s$(COLOR_RESET)\n" $$(($(HELP_WIDTH)-3)) "$(PROJECT_NAME) - Available Commands"
	@printf "$(COLOR_HEADER_FG)$(COLOR_HEADER_BG)%*s$(COLOR_RESET)\n" $(HELP_WIDTH) ""
	@echo ""
	@grep -hE '(^[[:alnum:]_.-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS=":.*?## "; color_section="$(COLOR_SECTION)"; color_target="$(COLOR_TARGET)"; color_reset="$(COLOR_RESET)"} \
			/^##/ { \
				gsub(/^##[[:space:]]*/, "", $$0); \
				if ($$0 != "") { \
					if (!seen_sections[$$0]++) { \
						if (NR > 1) { printf "\n" } \
						printf "%s%s%s\n", color_section, $$0, color_reset \
					} \
				} else { \
					printf "\n" \
				} \
				next \
			} \
			!seen_targets[$$1]++ { printf "  %s%-28s%s %s\n", color_target, $$1, color_reset, $$2 }'
	@echo ""
	@printf "$(COLOR_FOOTER_FG)$(COLOR_FOOTER_BG)%*s$(COLOR_RESET)\n" $(HELP_WIDTH) ""
	@printf "$(COLOR_FOOTER_FG)$(COLOR_FOOTER_BG)   Twitch: %-*s$(COLOR_RESET)\n" $$(($(HELP_WIDTH)-11)) "$(TWITCH_URL)"
	@printf "$(COLOR_FOOTER_FG)$(COLOR_FOOTER_BG)   GitLab: %-*s$(COLOR_RESET)\n" $$(($(HELP_WIDTH)-11)) "$(GITLAB_URL)"
	@printf "$(COLOR_FOOTER_FG)$(COLOR_FOOTER_BG)%*s$(COLOR_RESET)\n" $(HELP_WIDTH) ""
	@echo ""
