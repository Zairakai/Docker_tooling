#!/usr/bin/env bats

bats_require_minimum_version 1.5.0
load "../helpers/common"

# =============================================================================
# GIT MAINTENANCE SCRIPTS - Nettoyage et mise à jour
# =============================================================================

@test "git-cleanup.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/git-cleanup.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/git-cleanup.sh" ]]
}

@test "git-cleanup.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/git-cleanup.sh"
  [[ "$output" =~ ^#!/ ]]
}

@test "git-update.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/git-update.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/git-update.sh" ]]
}

@test "git-update.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/git-update.sh"
  [[ "$output" =~ ^#!/ ]]
}

# =============================================================================
# INSTALLATION SCRIPTS - Outils de développement
# =============================================================================

@test "install-bats.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/install-bats.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/install-bats.sh" ]]
}

@test "install-bats.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/install-bats.sh"
  [[ "$output" =~ ^#!/ ]]
}

@test "install-hadolint.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/install-hadolint.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/install-hadolint.sh" ]]
}

@test "install-hadolint.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/install-hadolint.sh"
  [[ "$output" =~ ^#!/ ]]
}

@test "install-markdownlint.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/install-markdownlint.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/install-markdownlint.sh" ]]
}

@test "install-markdownlint.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/install-markdownlint.sh"
  [[ "$output" =~ ^#!/ ]]
}

@test "install-shellcheck.sh exists and is executable" {
  [[ -f "${PROJECT_ROOT}/scripts/install-shellcheck.sh" ]]
  [[ -x "${PROJECT_ROOT}/scripts/install-shellcheck.sh" ]]
}

@test "install-shellcheck.sh has valid bash shebang" {
  run head -1 "${PROJECT_ROOT}/scripts/install-shellcheck.sh"
  [[ "$output" =~ ^#!/ ]]
}
