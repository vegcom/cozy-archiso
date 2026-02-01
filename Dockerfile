FROM archlinux:latest
WORKDIR /
COPY scripts/build.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]