FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    nginx \
    openssl \
    certbot python3-certbot-nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]


