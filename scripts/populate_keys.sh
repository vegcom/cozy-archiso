#!/bin/bash

. .env || true

rm -f build/airootfs/root/.ssh/* &>/dev/null|| true 
mkdir build/airootfs/root/.ssh/ &>/dev/null|| true 

find /home/$BUILD_USER/.ssh/keys/  -type f -not -name '*.bak*' -not -name "git*" -name "*.pub" | while read files ; do
  cat $files | tee -a build/airootfs/root/.ssh/authorized_keys 1>/dev/null 2>/dev/null
done
