#!/usr/bin/env bash
#
# Initialize project from Zairakai tooling templates
# Usage: bash tools/zairakai/scripts/init-project.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLING_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATES_DIR="${TOOLING_DIR}/templates"
PROJECT_ROOT="$(cd "${TOOLING_DIR}/../.." && pwd)"

echo "🎯 Initialize Project from Templates"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Prompt for project information
echo "→ Project Information"
echo ""

read -rp "Project name (e.g., e2e-testing): " PROJECT_NAME
read -rp "Project description: " PROJECT_DESCRIPTION
read -rp "GitLab group (e.g., zairakai/dockers): " GITLAB_GROUP
read -rp "Security email: " SECURITY_EMAIL
read -rp "Service Desk email: " SERVICE_DESK_EMAIL
read -rp "Docker image (e.g., zairakai/e2e-testing): " DOCKER_IMAGE

# URL-encode GitLab group
GITLAB_GROUP_ENCODED=$(echo "$GITLAB_GROUP" | sed 's/\//%2F/g')

echo ""
echo "📝 Generating Files"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Function to process template
process_template() {
    local template_file="$1"
    local output_file="$2"

    echo "→ Generating ${output_file}..."

    sed -e "s|{{PROJECT_NAME}}|${PROJECT_NAME}|g" \
        -e "s|{{PROJECT_DESCRIPTION}}|${PROJECT_DESCRIPTION}|g" \
        -e "s|{{GITLAB_GROUP}}|${GITLAB_GROUP}|g" \
        -e "s|{{GITLAB_GROUP_ENCODED}}|${GITLAB_GROUP_ENCODED}|g" \
        -e "s|{{SECURITY_EMAIL}}|${SECURITY_EMAIL}|g" \
        -e "s|{{SERVICE_DESK_EMAIL}}|${SERVICE_DESK_EMAIL}|g" \
        -e "s|{{DOCKER_IMAGE}}|${DOCKER_IMAGE}|g" \
        -e "s|{{YEAR}}|$(date +%Y)|g" \
        "${template_file}" > "${output_file}"

    echo "  ✅ Created"
}

# Function to copy file with confirmation
copy_with_confirm() {
    local source_file="$1"
    local dest_file="$2"
    local file_name
    file_name=$(basename "${dest_file}")

    if [ -f "${dest_file}" ]; then
        echo "⚠️  ${file_name} already exists"
        read -rp "   Overwrite? (y/N) " -n 1
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "${source_file}" "${dest_file}"
            echo "  ✅ Copied ${file_name}"
        fi
    else
        cp "${source_file}" "${dest_file}"
        echo "→ Copied ${file_name}"
        echo "  ✅ Created"
    fi
}

# Generate CONTRIBUTING.md
if [ -f "${PROJECT_ROOT}/CONTRIBUTING.md" ]; then
    echo "⚠️  CONTRIBUTING.md already exists"
    read -rp "   Overwrite? (y/N) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        process_template "${TEMPLATES_DIR}/CONTRIBUTING.md" "${PROJECT_ROOT}/CONTRIBUTING.md"
    fi
else
    process_template "${TEMPLATES_DIR}/CONTRIBUTING.md" "${PROJECT_ROOT}/CONTRIBUTING.md"
fi

# Generate SECURITY.md
if [ -f "${PROJECT_ROOT}/SECURITY.md" ]; then
    echo "⚠️  SECURITY.md already exists"
    read -rp "   Overwrite? (y/N) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        process_template "${TEMPLATES_DIR}/SECURITY.md" "${PROJECT_ROOT}/SECURITY.md"
    fi
else
    process_template "${TEMPLATES_DIR}/SECURITY.md" "${PROJECT_ROOT}/SECURITY.md"
fi

# Generate LICENSE
if [ -f "${PROJECT_ROOT}/LICENSE" ]; then
    echo "⚠️  LICENSE already exists"
    read -rp "   Overwrite? (y/N) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        process_template "${TEMPLATES_DIR}/LICENSE" "${PROJECT_ROOT}/LICENSE"
    fi
else
    process_template "${TEMPLATES_DIR}/LICENSE" "${PROJECT_ROOT}/LICENSE"
fi

# Copy .editorconfig
echo ""
copy_with_confirm "${TEMPLATES_DIR}/.editorconfig" "${PROJECT_ROOT}/.editorconfig"

# Symlink BATS helpers
echo ""
echo "→ Creating BATS helpers symlink..."
mkdir -p "${PROJECT_ROOT}/tests/helpers"

if [ -L "${PROJECT_ROOT}/tests/helpers/common.bash" ]; then
    echo "  ⚠️  Symlink already exists"
elif [ -f "${PROJECT_ROOT}/tests/helpers/common.bash" ]; then
    echo "  ⚠️  File already exists (not a symlink)"
    read -rp "   Replace with symlink? (y/N) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "${PROJECT_ROOT}/tests/helpers/common.bash"
        ln -s "../../tools/zairakai/tests/helpers/common.bash" "${PROJECT_ROOT}/tests/helpers/common.bash"
        echo "  ✅ Symlink created"
    fi
else
    ln -s "../../tools/zairakai/tests/helpers/common.bash" "${PROJECT_ROOT}/tests/helpers/common.bash"
    echo "  ✅ Symlink created"
fi

echo ""
echo "✅ Initialization Complete"
echo "━━━━━━━━━━━━━━━━"
echo ""
echo "Generated files:"
echo "  • CONTRIBUTING.md"
echo "  • SECURITY.md"
echo "  • LICENSE"
echo "  • .editorconfig"
echo "  • tests/helpers/common.bash (symlink)"
echo ""
echo "Available scripts:"
echo "  • tools/zairakai/.gitlab/scripts/ - CI/CD scripts"
echo "  • tools/zairakai/scripts/ - Development scripts"
echo ""
echo "Next steps:"
echo "  1. Review and customize generated files"
echo "  2. Run: make help"
echo "  3. Run: make ci-full"
echo ""
