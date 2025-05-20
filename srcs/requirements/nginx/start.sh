#!/bin/bash

set -e

CERT_PATH="/etc/nginx/certs"
CERT_FILE="${CERT_PATH}/cert.pem"
KEY_FILE="${CERT_PATH}/key.pem"

mkdir -p "$CERT_PATH"

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    if certbot certonly --non-interactive --agree-tos --nginx \
        -m "admin@${DOMAIN_NAME}" -d "${DOMAIN_NAME}" -d "www.${DOMAIN_NAME}"  > /dev/null 2>&1; then

        cp "/etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem" "$CERT_FILE"
        cp "/etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem" "$KEY_FILE"

        echo "SSL certificates created by certbot"

    else

        openssl req -x509 -nodes -days 365 \
            -newkey rsa:2048 \
            -keyout "$KEY_FILE" \
            -out "$CERT_FILE" \
            -subj "/C=FR/ST=NouvelleAquitaine/L=Angouleme/O=42/OU=Inception/CN=${DOMAIN_NAME}" > /dev/null 2>&1

        echo "Self-signed SSL certificates"
    fi
fi

nginx -g "daemon off;"
