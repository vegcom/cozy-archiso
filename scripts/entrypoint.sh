#!/usr/bin/env bash
set -euo pipefail
set -x

BUILD_DIR="/build"
WORK_DIR="${BUILD_DIR}/work"
OUT_DIR="/iso"

export WORK_DIR WORK_DIR OUT_DIR

mkdir -vp "${WORK_DIR}"

# If a command was passed, run it instead of building
if [[ $# -gt 0 ]]; then
    exec "$@"
fi


echo "==> Starting ArchISO build"
echo "    Build directory: ${BUILD_DIR}"
echo "    Work directory:  ${WORK_DIR}"
echo "    Output:          ${OUT_DIR}"

if [[ ! -f "${BUILD_DIR}/profiledef.sh" ]]; then 
  echo "ERROR: /build does not contain an ArchISO profile"
  ls -l "${BUILD_DIR}" 
  exit 1
fi

mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${BUILD_DIR}"

echo "==> Build complete"
