FROM archlinux:latest

RUN pacman -Sy --noconfirm \
    archiso \
    squashfs-tools \
    arch-install-scripts \
    && pacman -Scc --noconfirm

WORKDIR /build

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]