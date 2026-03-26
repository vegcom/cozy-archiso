#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="${BUILD_DIR:-./build}"
WORK_DIR="${WORK_DIR:-$BUILD_DIR/work}"
OUT_DIR="${OUT_DIR:-./iso}"

# If a command was passed, run it instead of building
if [[ $# -gt 0 ]]; then
    exec "$@"
fi

echo -e "\e[42m ==> Starting ArchISO clean...\e[0m"

if [[ -f /.dockerenv ]]; then
  pacman -Scc --noconfirm &>/dev/null
  pacman -Sy --noconfirm --needed archiso squashfs-tools  arch-install-scripts &>/dev/null
fi

echo -e "\e[42m ==> Create ArchISO environment...\e[0m"
pacman -S --noconfirm archiso squashfs-tools arch-install-scripts gettext &>/dev/null

echo -e "\e[42m ==> Starting ArchISO build...\e[0m"
echo -e "\e[33m    Build directory: ${BUILD_DIR}\e[0m"
echo -e "\e[33m    Work directory:  ${WORK_DIR}\e[0m"
echo -e "\e[33m    Output:          ${OUT_DIR}\e[0m"

if [[ ! -f "${BUILD_DIR}/profiledef.sh" ]]; then 
  echo -e  "\e[41m ERROR: ${BUILD_DIR} does not contain an ArchISO profile \e[0m"
  ls -l "${BUILD_DIR}" 
  exit 1
fi

echo -e "\e[42m ==> Generating salt minion keypair...\e[0m"
MINION_PKI="${BUILD_DIR}/airootfs/etc/salt/pki/minion"
mkdir -p "$MINION_PKI"
if [[ ! -f "$MINION_PKI/minion.pem" ]]; then
    openssl genrsa -out "$MINION_PKI/minion.pem" 4096 2>/dev/null
    openssl rsa -in "$MINION_PKI/minion.pem" -pubout -out "$MINION_PKI/minion.pub" 2>/dev/null
    chmod 700 "$MINION_PKI"
    chmod 600 "$MINION_PKI/minion.pem"
    chmod 644 "$MINION_PKI/minion.pub"
    echo -e "\e[33m    Keypair written to ${MINION_PKI}\e[0m"
else
    echo -e "\e[33m    Keypair already exists, skipping\e[0m"
fi

echo -e "\e[42m ==> Removing pacman lock just in case...\e[0m"
if ! rm -f /var/lib/pacman/db.lck &>/dev/null; then
  echo -e  "\e[41m ERROR: /var/lib/pacman/db.lck removal failed \e[0m"
fi

if ! mkarchiso -r -m iso -C "${BUILD_DIR}/pacman.conf" -w "${WORK_DIR}" -o "${OUT_DIR}" "${BUILD_DIR}" ; then
  echo -e "\e[41m ==> ...Build failed \e[0m"
else
  echo -e "\e[42m ==> ...Build complete \e[0m"
fi