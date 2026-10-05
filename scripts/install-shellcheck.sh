#!/usr/bin/env bash
#
# Install ShellCheck - Shell script static analysis
# https://github.com/koalaman/shellcheck
#
set -euo pipefail

CI_MODE="${CI:-false}"

echo "🐚 Installing ShellCheck"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Read version from .tool-versions if available
TOOL_VERSIONS_FILE="${ZAIRAKAI_ROOT:-.}/.tool-versions"
if [ -f "${TOOL_VERSIONS_FILE}" ]; then
    DESIRED_VERSION=$(grep "^shellcheck=" "${TOOL_VERSIONS_FILE}" | cut -d= -f2)
    echo "→ Found .tool-versions: ${DESIRED_VERSION}"
else
    DESIRED_VERSION="${SHELLCHECK_VERSION:-0.11.0}"
    echo "→ Using default version: ${DESIRED_VERSION}"
fi

# Function to compare versions
version_ge() {
    printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

# Check if already installed with acceptable version
if command -v shellcheck &>/dev/null; then
    CURRENT_VERSION=$(shellcheck --version | grep "version:" | awk '{print $2}')
    echo "→ Current version: ${CURRENT_VERSION}"

    if version_ge "${CURRENT_VERSION}" "${DESIRED_VERSION}"; then
        echo "✅ ShellCheck ${CURRENT_VERSION} is sufficient (need >=${DESIRED_VERSION})"
        exit 0
    fi

    echo "⚠️  Version ${CURRENT_VERSION} is outdated (need >=${DESIRED_VERSION})"

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

    if command -v apt-get &>/dev/null; then
        echo "→ Installing via apt-get..."
        if [ "${CI_MODE}" = "true" ] || [ "$(id -u)" -eq 0 ]; then
            apt-get update -qq
            apt-get install -y -qq shellcheck
        else
            sudo apt-get update -qq
            sudo apt-get install -y -qq shellcheck
        fi

    elif command -v dnf &>/dev/null; then
        echo "→ Installing via dnf..."
        if [ "${CI_MODE}" = "true" ] || [ "$(id -u)" -eq 0 ]; then
            dnf install -y -q ShellCheck
        else
            sudo dnf install -y -q ShellCheck
        fi

    elif command -v pacman &>/dev/null; then
        echo "→ Installing via pacman..."
        if [ "${CI_MODE}" = "true" ] || [ "$(id -u)" -eq 0 ]; then
            pacman -S --noconfirm --quiet shellcheck
        else
            sudo pacman -S --noconfirm --quiet shellcheck
        fi

    elif command -v apk &>/dev/null; then
        echo "→ Installing via apk..."
        apk add --no-cache -q shellcheck

    else
        echo "❌ Unsupported Linux distribution"
        echo "   Install manually from: https://github.com/koalaman/shellcheck"
        exit 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "→ Detected: macOS"

    if command -v brew &>/dev/null; then
        echo "→ Installing via Homebrew..."
        brew install shellcheck
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
echo "✅ ShellCheck installed successfully"
echo ""

# Verify installation
if command -v shellcheck &>/dev/null; then
    shellcheck --version
else
    echo "❌ ShellCheck installation failed"
    exit 1
fi
