FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y \
    php php-fpm php-mysql curl -y \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY www.conf /etc/php/7.4/fpm/pool.d/

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 9000

ENTRYPOINT ["/start.sh"]
