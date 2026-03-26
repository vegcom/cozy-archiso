#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="cozy-arch"
iso_label="COZY_ARCH"
iso_publisher="Vegcom"
iso_application="Cozy Arch Rescue ISO"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"

install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')

pacman_conf="pacman.conf"

airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  # cozy
  ["/etc/issue.net"]="0:0:644"
  ["/etc/issue"]="0:0:644"
  ["/etc/motd"]="0:0:644"
  ["/etc/ser2net.conf"]="0:0:600"
  ["/root/.ssh/authorized_keys"]="0:0:0600"
  ["/etc/salt/pki/minion"]="0:0:0700"
  ["/etc/salt/pki/minion/minion.pem"]="0:0:0600"
  ["/etc/salt/pki/minion/minion.pub"]="0:0:0644"
)
