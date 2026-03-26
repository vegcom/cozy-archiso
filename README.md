# cozy-archiso

```plain
   ╭────────────────────────────────────────╮
   │  cozy‑archiso — a warm little archiso  │
   ╰────────────────────────────────────────╯
                   (^-^)
                          ✧
                         ✧ ✧     Q(-_-q)
                       ✧  ✧  ✧
                         ✧ ✧
                          ✧
           (づ｡◕‿‿◕｡)づ
```

## Quick Start

```shell
# when building from an archlinux system
sudo mkarchiso -r -m iso -C build/pacman.conf  -w ./build/work  -o iso/ build/
```

```shell
# example of /dev/sda
sudo dd if=iso/cozy-arch-2026-01-27-2026-01-27.1769562672-x86_64.iso of=/dev/sda bs=4M status=progress oflag=sync
```
