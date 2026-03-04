#!/usr/bin/env bash
#
# Install markdownlint-cli2
# https://github.com/DavidAnson/markdownlint-cli2
#
set -euo pipefail

CI_MODE="${CI:-false}"

echo "📝 Installing markdownlint-cli2"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Check if npm is installed
if ! command -v npm &>/dev/null; then
    echo "❌ npm not found"
    echo "   Install Node.js from: https://nodejs.org"
    exit 1
fi

# Read version from .tool-versions if available
TOOL_VERSIONS_FILE="${ZAIRAKAI_ROOT:-.}/.tool-versions"
if [ -f "${TOOL_VERSIONS_FILE}" ]; then
    DESIRED_VERSION=$(grep "^markdownlint-cli2=" "${TOOL_VERSIONS_FILE}" | cut -d= -f2)
    echo "→ Found .tool-versions: ${DESIRED_VERSION}"
else
    DESIRED_VERSION="latest"
    echo "→ Using default version: ${DESIRED_VERSION}"
fi

# Check if already installed
if command -v markdownlint-cli2 &>/dev/null; then
    CURRENT_VERSION=$(markdownlint-cli2 --version 2>/dev/null || echo "unknown")
    echo "→ Current version: ${CURRENT_VERSION}"

    if [ "${DESIRED_VERSION}" != "latest" ] && [ "${CURRENT_VERSION}" = "${DESIRED_VERSION}" ]; then
        echo "✅ markdownlint-cli2 ${CURRENT_VERSION} already installed"
        exit 0
    fi

    if [ "${CI_MODE}" != "true" ]; then
        read -rp "Reinstall? (y/N) " -n 1
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "✅ Keeping existing installation"
            exit 0
        fi
    else
        echo "→ CI mode: reinstalling automatically"
    fi
fi

# Install
echo "→ Installing via npm..."
if [ "${DESIRED_VERSION}" = "latest" ]; then
    npm install -g markdownlint-cli2
else
    npm install -g "markdownlint-cli2@${DESIRED_VERSION}"
fi

echo ""
echo "✅ markdownlint-cli2 installed successfully"
echo ""

# Verify installation
if command -v markdownlint-cli2 &>/dev/null; then
    markdownlint-cli2 --version
else
    echo "❌ markdownlint-cli2 installation failed"
    exit 1
fi
