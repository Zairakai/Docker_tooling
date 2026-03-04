# Core Makefile - Zairakai Tooling
# Aggregates all modular targets

.DEFAULT_GOAL := help

# Ensure SHELL is bash for script compatibility
SHELL := /bin/bash

# Detect tooling location
ZAIRAKAI_TOOLING_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Include variables first (paths, colors, config)
include $(ZAIRAKAI_TOOLING_DIR)variables.mk

# Include specialized makefiles in logical order
include $(ZAIRAKAI_TOOLING_DIR)help.mk
include $(ZAIRAKAI_TOOLING_DIR)markdownlint.mk
include $(ZAIRAKAI_TOOLING_DIR)shellcheck.mk
include $(ZAIRAKAI_TOOLING_DIR)hadolint.mk
include $(ZAIRAKAI_TOOLING_DIR)quality.mk
include $(ZAIRAKAI_TOOLING_DIR)bats.mk
include $(ZAIRAKAI_TOOLING_DIR)utils.mk
