#!/usr/bin/env bash
set -euo pipefail

# Check the tag of a release of a base image (node, php) against its Dockerfile.
#
# The tag is the version of the base image the Dockerfile builds on (24.22.2), or
# that version with a revision (24.22.2-1) for a new build of the same upstream
# version. Anything else, a pre-release (24.22.2-rc.1) included, is refused.
#
# Required environment:
#   CI_COMMIT_TAG  tag of the pipeline
#   VERSION_ENV    env variable that holds the version in the base image (NODE_VERSION, PHP_VERSION)
# Needs crane, and the Dockerfile in the current directory.

# shellcheck source-path=SCRIPTDIR
# shellcheck source=freshness-check.sh
source "$(dirname "${BASH_SOURCE[0]}")/freshness-check.sh"

# True for X.Y.Z or X.Y.Z-N.
is_release_tag() {
    [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?$ ]]
}

# The version part of a release tag: 24.22.2-1 gives 24.22.2.
tag_version() {
    echo "${1%%-*}"
}

check_tag() {
    : "${CI_COMMIT_TAG:?}" "${VERSION_ENV:?}"
    local tag="${CI_COMMIT_TAG}" base version

    if ! is_release_tag "${tag}"; then
        echo "ERROR: the tag \"${tag}\" is not X.Y.Z or X.Y.Z-N (a pre-release is not published)."
        return 1
    fi

    base=$(upstream_from_dockerfile Dockerfile)
    version=$(image_env "$(crane config "${base}")" "${VERSION_ENV}")
    if [[ "$(tag_version "${tag}")" != "${version}" ]]; then
        echo "ERROR: the tag \"${tag}\" does not match ${VERSION_ENV}=${version} of ${base}."
        echo "       Tag the image with ${version}, or ${version}-N for a new build of that version."
        return 1
    fi
    echo "Tag ${tag}: matches ${base} (${version})"
}

# Run only when executed, so the tests can source the helpers.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_tag
fi
