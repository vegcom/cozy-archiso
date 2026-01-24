#!/bin/bash
if bash scripts/populate_keys.sh ; then
  echo '✅ populate_keys: succeded'
else
  echo '⚠️ populate_keys: failed'
fi

if sudo bash scripts/build_iso.sh ; then
  echo '✅ build_iso: succeded'
else
  echo '⚠️ build_iso: failed'
fi