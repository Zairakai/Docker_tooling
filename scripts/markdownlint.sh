#!/usr/bin/env bash
#
# Run markdownlint on all Markdown files
#
set -euo pipefail

FIX_MODE="${1:-}"

if [ "$FIX_MODE" = "--fix" ]; then
    echo "📝 Markdownlint (Auto-fix Mode)"
else
    echo "📝 Markdownlint Validation"
fi
echo "━━━━━━━━━━━━━━━━"
echo ""

# Check which tool is available
if command -v markdownlint-cli2 &>/dev/null; then
    TOOL="markdownlint-cli2"
elif command -v markdownlint &>/dev/null; then
    TOOL="markdownlint"
else
    echo "❌ markdownlint not installed"
    echo "   Run: make install-markdownlint"
    exit 1
fi

echo "→ Using: ${TOOL}"

# Build exclusion patterns
EXCLUDE_PATHS=()

# Read patterns from .markdownlintignore
if [ -f .markdownlintignore ]; then
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        # Remove trailing / and add to exclusions
        pattern="${line%/}"
        EXCLUDE_PATHS+=("${pattern}")
    done < .markdownlintignore
fi

# Add submodules to exclusions
if [ -f .gitmodules ]; then
    SUBMODULES=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
    if [ -n "$SUBMODULES" ]; then
        echo "→ Detected Git submodules:"
        while IFS= read -r submodule; do
            echo "  - ${submodule}"
            EXCLUDE_PATHS+=("${submodule}")
        done <<< "$SUBMODULES"
    fi
fi
echo ""

# Build find command with exclusions
FIND_ARGS=("." "-type" "f" "-name" "*.md")

for path in "${EXCLUDE_PATHS[@]}"; do
    FIND_ARGS+=("!" "-path" "./${path}/*")
done

# Exclude *.min.md files
FIND_ARGS+=("!" "-name" "*.min.md")

# Find all markdown files
echo "→ Finding Markdown files..."
MD_FILES=$(find "${FIND_ARGS[@]}")

if [ -z "$MD_FILES" ]; then
    echo "⚠️  No Markdown files found"
    exit 0
fi

FILE_COUNT=$(echo "$MD_FILES" | wc -l | tr -d ' ')
echo "→ Found ${FILE_COUNT} Markdown file(s)"
echo ""

# Run markdownlint
if [ "$TOOL" = "markdownlint-cli2" ]; then
    if [ "$FIX_MODE" = "--fix" ]; then
        echo "→ Auto-fixing Markdown files..."
        echo "$MD_FILES" | xargs markdownlint-cli2 --fix --config .markdownlint.json
    else
        echo "→ Validating Markdown files..."
        echo "$MD_FILES" | xargs markdownlint-cli2 --config .markdownlint.json
    fi
else
    if [ "$FIX_MODE" = "--fix" ]; then
        echo "→ Auto-fixing Markdown files..."
        echo "$MD_FILES" | xargs markdownlint --fix
    else
        echo "→ Validating Markdown files..."
        echo "$MD_FILES" | xargs markdownlint
    fi
fi

echo ""
if [ "$FIX_MODE" = "--fix" ]; then
    echo "✅ Markdown files fixed"
else
    echo "✅ All Markdown files passed validation"
fi
