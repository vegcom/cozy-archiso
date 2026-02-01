#!/bin/bash
# secrets.sh - Template secrets from .env into ISO airootfs
# Run during ISO build (before mkarchiso)
#
# Usage: ./scripts/secrets.sh
# Requires: .env with GH_TOKEN and SSH_PKEY

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
AIROOTFS="$ROOT_DIR/build/airootfs"

# Validate required vars
[[ -z "${GH_TOKEN:-}" ]] && echo "Warning: GH_TOKEN not set"
[[ -z "${SSH_PKEY:-}" ]] && echo "Warning: SSH_PKEY not set"


# Template GH_TOKEN into /etc/profile.d/
mkdir -p "$AIROOTFS/etc/profile.d"
cat > "$AIROOTFS/etc/profile.d/cozy-secrets.sh" << 'TEMPLATE'
#!/bin/bash
# Cozy secrets - baked at ISO build time
export GH_TOKEN='${GH_TOKEN}'
export GITHUB_TOKEN='${GH_TOKEN}'
TEMPLATE

envsubst '${GH_TOKEN}' < "$AIROOTFS/etc/profile.d/cozy-secrets.sh" > "$AIROOTFS/etc/profile.d/cozy-secrets.sh.tmp"
mv "$AIROOTFS/etc/profile.d/cozy-secrets.sh.tmp" "$AIROOTFS/etc/profile.d/cozy-secrets.sh"
chmod 644 "$AIROOTFS/etc/profile.d/cozy-secrets.sh"

# Template SSH key into /root/.ssh/
mkdir -p "$AIROOTFS/root/.ssh"
chmod 700 "$AIROOTFS/root/.ssh"

if [[ -n "${SSH_PKEY:-}" ]]; then
    echo "$SSH_PKEY" > "$AIROOTFS/root/.ssh/authorized_keys"
    chmod 600 "$AIROOTFS/root/.ssh/authorized_keys"
    echo "SSH key written to airootfs/root/.ssh/authorized_keys"
fi

echo "Secrets templated into airootfs"
