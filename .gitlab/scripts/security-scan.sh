#!/usr/bin/env bash
#
# Security scan Docker image with Trivy
# Usage: bash .gitlab/scripts/security-scan.sh <image_name> <tag>
#
set -euo pipefail

IMAGE_NAME="${1:-}"
IMAGE_TAG="${2:-latest}"

if [ -z "${IMAGE_NAME}" ]; then
    echo "❌ Image name required"
    echo "   Usage: $0 <image_name> <tag>"
    exit 1
fi

echo "🔒 Security Scanning"
echo "━━━━━━━━━━━━━━━━"
echo ""

# Check if Trivy is installed
if ! command -v trivy &>/dev/null; then
    echo "→ Installing Trivy..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Install via script
        curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
    else
        echo "❌ Trivy installation not supported on ${OSTYPE}"
        echo "   Install manually: https://aquasecurity.github.io/trivy/latest/getting-started/installation/"
        exit 1
    fi
fi

echo "→ Scanning ${IMAGE_NAME}:${IMAGE_TAG}..."
echo ""

# Run scan
SEVERITY="${TRIVY_SEVERITY:-CRITICAL,HIGH}"
EXIT_CODE="${TRIVY_EXIT_CODE:-1}"

trivy image \
    --severity "${SEVERITY}" \
    --exit-code "${EXIT_CODE}" \
    --no-progress \
    "${IMAGE_NAME}:${IMAGE_TAG}"

SCAN_RESULT=$?

echo ""
if [ ${SCAN_RESULT} -eq 0 ]; then
    echo "✅ No vulnerabilities found"
else
    echo "❌ Vulnerabilities detected"
    echo "   Review the report above"
fi

exit ${SCAN_RESULT}
