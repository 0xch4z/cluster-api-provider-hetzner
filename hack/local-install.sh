#!/usr/bin/env bash
# Build and install the local CAPH provider for use with clusterctl.
#
# This script:
#   1. Builds infrastructure-components.yaml from config/default
#   2. Stages it in the directory layout clusterctl expects for local providers
#   3. Writes ~/.cluster-api/clusterctl.yaml pointing to the local provider
#
# Usage:
#   ./hack/local-install.sh                # build + write clusterctl config
#   ./hack/local-install.sh --build-only   # build only, don't touch clusterctl config

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROVIDER_VERSION="${CAPH_VERSION:-v1.2.0}"
PROVIDER_DIR="${REPO_ROOT}/out/infrastructure-hetzner/${PROVIDER_VERSION}"
CLUSTERCTL_CONFIG="${HOME}/.cluster-api/clusterctl.yaml"

echo "Building provider manifests and cluster templates ..."
cd "${REPO_ROOT}"
make release-manifests 2>&1 | tail -1

mkdir -p "${PROVIDER_DIR}"
cp out/infrastructure-components.yaml "${PROVIDER_DIR}/"
cp out/metadata.yaml "${PROVIDER_DIR}/"
cp out/cluster-template* "${PROVIDER_DIR}/" 2>/dev/null || true
cp out/cluster-class* "${PROVIDER_DIR}/" 2>/dev/null || true

echo "Provider staged at: ${PROVIDER_DIR}"

if [[ "${1:-}" == "--build-only" ]]; then
  exit 0
fi

echo "Writing ${CLUSTERCTL_CONFIG} ..."
mkdir -p "$(dirname "${CLUSTERCTL_CONFIG}")"
cat > "${CLUSTERCTL_CONFIG}" <<EOF
providers:
  - name: "hetzner"
    url: "${PROVIDER_DIR}/infrastructure-components.yaml"
    type: "InfrastructureProvider"
  - name: "talos"
    url: "https://github.com/siderolabs/cluster-api-bootstrap-provider-talos/releases/latest/bootstrap-components.yaml"
    type: "BootstrapProvider"
  - name: "talos"
    url: "https://github.com/siderolabs/cluster-api-control-plane-provider-talos/releases/latest/control-plane-components.yaml"
    type: "ControlPlaneProvider"
EOF

echo "Done. You can now run:"
echo "  clusterctl init --infrastructure hetzner --bootstrap talos --control-plane talos"
