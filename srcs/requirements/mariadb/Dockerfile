FROM debian:bullseye

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 3306

ENTRYPOINT ["/start.sh"]
