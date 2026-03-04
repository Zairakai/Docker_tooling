#!/usr/bin/env bats

bats_require_minimum_version 1.5.0
load "../helpers/common"

# =============================================================================
# MARKDOWNLINT.SH - Validation de la documentation Markdown
# =============================================================================

@test "markdownlint.sh exists and is executable" {
    echo $PROJECT_ROOT
    pwd
  [[ -f "${PROJECT_ROOT}/scripts/markdownlint.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/markdownlint.sh" ]]
}

@test "markdownlint.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/markdownlint.sh"
  [[ "$output" =~ ^#!/ ]]
}

# =============================================================================
# SHELLCHECK.SH - Validation des scripts shell
# =============================================================================

@test "shellcheck.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/shellcheck.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/shellcheck.sh" ]]
}

@test "shellcheck.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/shellcheck.sh"
  [[ "$output" =~ ^#!/ ]]
}
