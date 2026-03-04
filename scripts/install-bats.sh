#!/usr/bin/env bash
#
# Install BATS (Bash Automated Testing System)
# https://github.com/bats-core/bats-core
#
set -euo pipefail

CI_MODE="${CI:-false}"
INSTALL_DIR="${BATS_INSTALL_DIR:-/usr/local}"

echo "🧪 Installing BATS"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Read version from .tool-versions if available
TOOL_VERSIONS_FILE="${ZAIRAKAI_ROOT:-.}/.tool-versions"
if [ -f "${TOOL_VERSIONS_FILE}" ]; then
    BATS_VERSION=$(grep "^bats=" "${TOOL_VERSIONS_FILE}" | cut -d= -f2)
    echo "→ Found .tool-versions: ${BATS_VERSION}"
else
    BATS_VERSION="${BATS_VERSION:-1.11.0}"
    echo "→ Using default version: ${BATS_VERSION}"
fi

# Ensure version has 'v' prefix
if [[ ! "$BATS_VERSION" =~ ^v ]]; then
    BATS_VERSION="v${BATS_VERSION}"
fi

# Function to compare versions (without 'v' prefix)
version_ge() {
    local ver1="${1#v}"
    local ver2="${2#v}"
    printf '%s\n%s\n' "$ver2" "$ver1" | sort -V -C
}

# Check if already installed
if command -v bats &>/dev/null; then
    CURRENT_VERSION=$(bats --version | awk '{print $2}')
    echo "→ Current version: ${CURRENT_VERSION}"

    if version_ge "${CURRENT_VERSION}" "${BATS_VERSION}"; then
        echo "✅ BATS ${CURRENT_VERSION} is sufficient (need >=${BATS_VERSION})"
        exit 0
    fi

    echo "⚠️  Version ${CURRENT_VERSION} is outdated (need >=${BATS_VERSION})"

    if [ "${CI_MODE}" != "true" ]; then
        read -rp "Upgrade? (y/N) " -n 1
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "✅ Keeping existing installation"
            exit 0
        fi
    else
        echo "→ CI mode: upgrading automatically"
    fi
fi

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "→ Detected: Linux"

    # Clone BATS
    echo "→ Cloning BATS ${BATS_VERSION}..."
    TEMP_DIR=$(mktemp -d)
    if ! git clone --depth 1 --branch "${BATS_VERSION}" https://github.com/bats-core/bats-core.git "${TEMP_DIR}"; then
        echo "❌ Failed to clone BATS"
        rm -rf "${TEMP_DIR}"
        exit 1
    fi

    # Install
    echo "→ Installing to ${INSTALL_DIR}..."
    if [ -w "${INSTALL_DIR}" ]; then
        bash "${TEMP_DIR}/install.sh" "${INSTALL_DIR}"
    else
        if [ "${CI_MODE}" = "true" ] || [ "$(id -u)" -eq 0 ]; then
            bash "${TEMP_DIR}/install.sh" "${INSTALL_DIR}"
        else
            sudo bash "${TEMP_DIR}/install.sh" "${INSTALL_DIR}"
        fi
    fi

    # Cleanup
    rm -rf "${TEMP_DIR}"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "→ Detected: macOS"

    if command -v brew &>/dev/null; then
        echo "→ Installing via Homebrew..."
        brew install bats-core
    else
        echo "❌ Homebrew not found"
        echo "   Install from: https://brew.sh"
        exit 1
    fi
else
    echo "❌ Unsupported OS: ${OSTYPE}"
    exit 1
fi

echo ""
echo "✅ BATS installed successfully"
echo ""

# Verify installation
if command -v bats &>/dev/null; then
    bats --version
else
    echo "❌ BATS installation failed"
    exit 1
fi
