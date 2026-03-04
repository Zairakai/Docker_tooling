#!/usr/bin/env bash
#
# Update all Git submodules declared in .gitmodules
#
set -euo pipefail

echo "🔄 Git SubModules Update"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Exit early if no .gitmodules
if [ ! -f .gitmodules ]; then
    echo "ℹ️ No .gitmodules file found — nothing to update"
    exit 0
fi

# Get all submodule names
mapfile -t SUBMODULES < <(
    git config --file .gitmodules --name-only --get-regexp '^submodule\..*\.path$' \
    | sed 's/^submodule\.//;s/\.path$//'
)

if [ "${#SUBMODULES[@]}" -eq 0 ]; then
    echo "ℹ️ No submodules declared in .gitmodules"
    exit 0
fi

for SUBMODULE in "${SUBMODULES[@]}"; do
    echo "▶ Handling submodule: ${SUBMODULE}"

    SUBMODULE_PATH="$(git config --file .gitmodules --get "submodule.${SUBMODULE}.path")"
    SUBMODULE_URL="$(git config --file .gitmodules --get "submodule.${SUBMODULE}.url")"
    SUBMODULE_BRANCH="$(git config --file .gitmodules --get "submodule.${SUBMODULE}.branch" || true)"

    if [ -z "${SUBMODULE_PATH}" ] || [ -z "${SUBMODULE_URL}" ]; then
        echo "❌ Invalid submodule definition: ${SUBMODULE}"
        exit 1
    fi

    # If submodule missing from index, re-add it
    if ! git ls-files --stage | grep -q "${SUBMODULE_PATH}"; then
        echo "⚠️ Submodule '${SUBMODULE_PATH}' missing — re-adding"

        if [ -n "${SUBMODULE_BRANCH}" ]; then
            git submodule add -b "${SUBMODULE_BRANCH}" "${SUBMODULE_URL}" "${SUBMODULE_PATH}"
        else
            git submodule add "${SUBMODULE_URL}" "${SUBMODULE_PATH}"
        fi
    fi
done

# Final sync & update
git submodule sync --recursive
git submodule update --init --remote --merge

echo ""
echo "✅ SubModules update completed"
