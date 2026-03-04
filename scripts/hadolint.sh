#!/usr/bin/env bash
#
# Run Hadolint on Dockerfile
#
set -euo pipefail

echo "🐳 Hadolint Validation"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Find Dockerfile
if [ ! -f "Dockerfile" ]; then
    echo "⚠️  No Dockerfile found"
    exit 0
fi

echo "→ Validating Dockerfile..."
echo ""

# Run hadolint
if hadolint Dockerfile; then
    echo ""
    echo "✅ Dockerfile passed validation"
    exit 0
else
    echo ""
    echo "❌ Dockerfile validation failed"
    echo ""
    echo "Fix all issues before committing."
    exit 1
fi
