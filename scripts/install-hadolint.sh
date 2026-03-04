#!/usr/bin/env bash
#
# Install Hadolint - Dockerfile linter
# https://github.com/hadolint/hadolint
#
set -euo pipefail

CI_MODE="${CI:-false}"
INSTALL_DIR="${HADOLINT_INSTALL_DIR:-/usr/local/bin}"

echo "🐳 Installing Hadolint"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Read version from .tool-versions if available
TOOL_VERSIONS_FILE="${ZAIRAKAI_ROOT:-.}/.tool-versions"
if [ -f "${TOOL_VERSIONS_FILE}" ]; then
    HADOLINT_VERSION=$(grep "^hadolint=" "${TOOL_VERSIONS_FILE}" | cut -d= -f2)
    echo "→ Found .tool-versions: ${HADOLINT_VERSION}"
else
    HADOLINT_VERSION="${HADOLINT_VERSION:-2.12.0}"
    echo "→ Using default version: ${HADOLINT_VERSION}"
fi

# Ensure version has 'v' prefix
if [[ ! "$HADOLINT_VERSION" =~ ^v ]]; then
    HADOLINT_VERSION="v${HADOLINT_VERSION}"
fi

# Function to compare versions (without 'v' prefix)
version_ge() {
    local ver1="${1#v}"
    local ver2="${2#v}"
    printf '%s\n%s\n' "$ver2" "$ver1" | sort -V -C
}

# Check if already installed with acceptable version
if command -v hadolint &>/dev/null; then
    CURRENT_VERSION=$(hadolint --version | head -n1 | awk '{print $4}')
    echo "→ Current version: ${CURRENT_VERSION}"

    if version_ge "${CURRENT_VERSION}" "${HADOLINT_VERSION}"; then
        echo "✅ Hadolint ${CURRENT_VERSION} is sufficient (need >=${HADOLINT_VERSION})"
        exit 0
    fi

    echo "⚠️  Version ${CURRENT_VERSION} is outdated (need >=${HADOLINT_VERSION})"

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

# Detect OS and architecture
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="Darwin"
else
    echo "❌ Unsupported OS: ${OSTYPE}"
    exit 1
fi

ARCH=$(uname -m)
case ${ARCH} in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    *)
        echo "❌ Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Download URL
DOWNLOAD_URL="https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-${OS}-${ARCH}"

echo "→ Downloading from ${DOWNLOAD_URL}..."
TEMP_FILE=$(mktemp)
if ! curl -sL "${DOWNLOAD_URL}" -o "${TEMP_FILE}"; then
    echo "❌ Failed to download Hadolint"
    rm -f "${TEMP_FILE}"
    exit 1
fi

# Install
echo "→ Installing to ${INSTALL_DIR}/hadolint..."
if [ -w "${INSTALL_DIR}" ]; then
    mv "${TEMP_FILE}" "${INSTALL_DIR}/hadolint"
    chmod +x "${INSTALL_DIR}/hadolint"
else
    if [ "${CI_MODE}" = "true" ] || [ "$(id -u)" -eq 0 ]; then
        mv "${TEMP_FILE}" "${INSTALL_DIR}/hadolint"
        chmod +x "${INSTALL_DIR}/hadolint"
    else
        sudo mv "${TEMP_FILE}" "${INSTALL_DIR}/hadolint"
        sudo chmod +x "${INSTALL_DIR}/hadolint"
    fi
fi

echo ""
echo "✅ Hadolint installed successfully"
echo ""

# Verify installation
if command -v hadolint &>/dev/null; then
    hadolint --version
else
    echo "❌ Hadolint installation failed"
    exit 1
fi
