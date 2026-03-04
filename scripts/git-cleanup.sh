#!/usr/bin/env bash
#
# Remove local branches whose remote tracking branch no longer exists
#
set -euo pipefail

echo "🧹 Git Branch Cleanup"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Fetch and prune
echo "→ Fetching and pruning remote references..."
git fetch --all --prune
echo ""

# Find merged branches (exclude main, master, develop)
echo "→ Finding merged branches..."
MERGED_BRANCHES=$(git branch --merged | grep -vE '^\*|main$|master$|develop$' || true)

if [ -z "$MERGED_BRANCHES" ]; then
    echo "  No merged branches to clean up"
else
    echo "$MERGED_BRANCHES" | while read -r branch; do
        branch=$(echo "$branch" | xargs)  # Trim whitespace
        echo "  • ${branch}"
    done
    echo ""

    read -p "Delete these branches? (y/N) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$MERGED_BRANCHES" | while read -r branch; do
            branch=$(echo "$branch" | xargs)
            echo "→ Deleting ${branch}..."
            git branch -d "$branch"
        done
        echo ""
        echo "✅ Cleanup completed"
    else
        echo "⏭️  Skipped"
    fi
fi

# Find branches with gone upstream
echo ""
echo "→ Finding branches with gone upstream..."
GONE_BRANCHES=$(git branch -vv | grep ': gone]' | awk '{print $1}' | grep -v '^\*' || true)

if [ -z "$GONE_BRANCHES" ]; then
    echo "  No branches with gone upstream"
else
    echo "$GONE_BRANCHES" | while read -r branch; do
        echo "  • ${branch}"
    done
    echo ""

    read -p "Delete these branches? (y/N) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$GONE_BRANCHES" | while read -r branch; do
            echo "→ Deleting ${branch}..."
            git branch -D "$branch"
        done
        echo ""
        echo "✅ Cleanup completed"
    else
        echo "⏭️  Skipped"
    fi
fi

echo ""
echo "✅ Git cleanup finished"
