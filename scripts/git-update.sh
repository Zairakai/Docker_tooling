#!/usr/bin/env bash
#
# Fast-forward all local branches that track a remote
#
set -euo pipefail

echo "🔄 Git Branch Update"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Save current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "→ Fetching all remotes..."
git fetch --all --prune
echo ""

# Get all branches with upstream
echo "→ Updating branches..."
git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads | while read -r local remote; do
    if [ -n "$remote" ]; then
        echo "  • ${local} ← ${remote}"

        # Check if fast-forward is possible
        MERGE_BASE=$(git merge-base "$local" "$remote" 2>/dev/null || echo "")
        LOCAL_COMMIT=$(git rev-parse "$local" 2>/dev/null || echo "")

        if [ -n "$MERGE_BASE" ] && [ "$MERGE_BASE" = "$LOCAL_COMMIT" ]; then
            # Can fast-forward
            git update-ref "refs/heads/$local" "$remote"
            echo "    ✅ Fast-forwarded"
        else
            echo "    ⏭️  Skipped (diverged or up-to-date)"
        fi
    fi
done

echo ""

# Return to original branch
if [ "$(git rev-parse --abbrev-ref HEAD)" != "$CURRENT_BRANCH" ]; then
    echo "→ Returning to ${CURRENT_BRANCH}..."
    git checkout "$CURRENT_BRANCH"
fi

echo ""
echo "✅ Update completed"
