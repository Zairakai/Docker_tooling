#!/usr/bin/env bats

bats_require_minimum_version 1.5.0

# =============================================================================
# check-tag-version.sh - tag of a base image release
# =============================================================================

use_script() {
  PROJECT_ROOT="${PROJECT_ROOT:-$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)}"
  SCRIPT="${PROJECT_ROOT}/.gitlab/scripts/check-tag-version.sh"
  # shellcheck source=/dev/null
  source "${SCRIPT}"
}

@test "check-tag-version.sh exists and is executable" {
  use_script
  [[ -x "${SCRIPT}" ]]
}

@test "is_release_tag accepts X.Y.Z and X.Y.Z-N" {
  use_script
  is_release_tag 24.22.2
  is_release_tag 8.4.27-1
  is_release_tag 8.4.27-12
}

@test "is_release_tag refuses pre-releases and other forms" {
  use_script
  ! is_release_tag 8.4.27-rc.1
  ! is_release_tag v8.4.27
  ! is_release_tag 8.4
  ! is_release_tag 8.4.27-
  ! is_release_tag 8.4.27-1-2
}

@test "tag_version drops the revision" {
  use_script
  [[ "$(tag_version 24.22.2)" == "24.22.2" ]]
  [[ "$(tag_version 24.22.2-3)" == "24.22.2" ]]
}
