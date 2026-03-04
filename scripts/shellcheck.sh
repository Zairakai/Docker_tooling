#!/usr/bin/env bash
#
# Run ShellCheck on all shell scripts
# 100% compliance required - ZERO warnings tolerated
#
set -euo pipefail

echo "🐚 ShellCheck Validation"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Find all shell scripts
SCRIPTS=$(find tools/scripts .gitlab/scripts scripts -name "*.sh" -type f 2>/dev/null || true)

if [ -z "$SCRIPTS" ]; then
    echo "⚠️  No shell scripts found to validate"
    exit 0
fi

echo "→ Found scripts:"
echo "$SCRIPTS" | while read -r script; do
    echo "  • ${script}"
done
echo ""

# Run ShellCheck
echo "→ Running ShellCheck (severity: warning)..."
echo ""

FAILED=0
while IFS= read -r script; do
    echo "Checking ${script}..."
    if ! shellcheck --severity=warning "${script}"; then
        FAILED=1
    fi
done <<< "$SCRIPTS"

echo ""
if [ ${FAILED} -eq 0 ]; then
    echo "✅ All scripts passed ShellCheck (100% compliance)"
    exit 0
else
    echo "❌ ShellCheck validation failed"
    echo ""
    echo "Fix all warnings before committing."
    exit 1
fi
