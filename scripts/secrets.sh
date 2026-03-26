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
cp "$AIROOTFS/etc/profile.d/cozy-secrets.sh.tmp" "$AIROOTFS/etc/profile.d/cozy-secrets.sh"
chmod 644 "$AIROOTFS/etc/profile.d/cozy-secrets.sh" &>/dev/null

# Template SSH key into /root/.ssh/
mkdir -p "$AIROOTFS/root/.ssh" &>/dev/null
chmod 700 "$AIROOTFS/root/.ssh" &>/dev/null

if [[ -n "${SSH_PKEY:-}" ]]; then
    echo "$SSH_PKEY" > "$AIROOTFS/root/.ssh/authorized_keys"
    chmod 600 "$AIROOTFS/root/.ssh/authorized_keys"
    echo "SSH key written to airootfs/root/.ssh/authorized_keys"
fi

echo "Secrets templated into airootfs"

# Generate salt minion keypair and bake into airootfs
# Pre-baked keys mean the master auto-accepts on first contact — no manual salt-key needed.
MINION_PKI="$AIROOTFS/etc/salt/pki/minion"
COZY_SALT_KEYS="${COZY_SALT_KEYS:-}"

mkdir -p "$MINION_PKI"

if [[ ! -f "$MINION_PKI/minion.pem" ]]; then
    openssl genrsa -out "$MINION_PKI/minion.pem" 4096 2>/dev/null
    openssl rsa -in "$MINION_PKI/minion.pem" -pubout -out "$MINION_PKI/minion.pub" 2>/dev/null
    echo "Salt minion keypair generated"
else
    echo "Salt minion keypair already exists, skipping"
fi

# Copy pubkey to cozy-salt accepted keys if COZY_SALT_KEYS is set
if [[ -n "$COZY_SALT_KEYS" && -d "$COZY_SALT_KEYS" ]]; then
    cp "$MINION_PKI/minion.pub" "$COZY_SALT_KEYS/arch-iso.pub"
    echo "Pubkey copied to cozy-salt: $COZY_SALT_KEYS/arch-iso.pub"
else
    echo "Note: set COZY_SALT_KEYS=/path/to/cozy-salt/srv/salt/keys/minion to auto-accept in master"
fi
