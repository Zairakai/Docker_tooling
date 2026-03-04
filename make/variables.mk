# Variables - Zairakai Tooling
# Shared configuration and styling

# Critical path detection - works from any inclusion depth
TOOLS_MAKE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT_ROOT := $(abspath $(TOOLS_MAKE_DIR)../../..)
ZAIRAKAI_ROOT := $(abspath $(TOOLS_MAKE_DIR)../)/
ZAIRAKAI_SCRIPTS_DIR := $(ZAIRAKAI_ROOT)scripts/

# Validate paths exist
ifeq ($(wildcard $(ZAIRAKAI_SCRIPTS_DIR)),)
$(error Zairakai scripts directory not found: $(ZAIRAKAI_SCRIPTS_DIR))
endif

# Project information (can be overridden in project Makefile BEFORE including core.mk)
PROJECT_NAME ?= Zairakai Project
TWITCH_URL ?= https://twitch.tv/zairakai
GITLAB_URL ?= https://gitlab.com/zairakai

# Help styling
HELP_WIDTH := 70

# ANSI Colors (only used in Make, no export)
COLOR_RESET := \033[0m
COLOR_HEADER_BG := \033[46m
COLOR_HEADER_FG := \033[1;37m
COLOR_SECTION := \033[1;33m
COLOR_TARGET := \033[32m
COLOR_FOOTER_BG := \033[44m
COLOR_FOOTER_FG := \033[1;37m

# Export only what shell scripts need
export PROJECT_ROOT
export ZAIRAKAI_ROOT
export ZAIRAKAI_SCRIPTS_DIR
export PROJECT_NAME
export TWITCH_URL
export GITLAB_URL
