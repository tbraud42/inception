#!/bin/sh

set -e

mkdir -p /run/php
chown -R www-data:www-data /run/php

if [ ! -f "/var/www/html/wp-config.php" ]
then
	if [ -z "$DOMAIN_NAME" ] || [ -z "$WP_TITLE" ] || [ -z "$WP_ROOT_USER" ] || \
	     [ -z "$WP_ROOT_PASSWORD" ] || [ -z "$WP_ROOT_EMAIL" ]; then
		echo "missing error: missing variable"
		exit 1
	fi
	wp core download --path="/var/www/html" --allow-root
	wp config create --path="/var/www/html" --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_DB_HOST --skip-check
	wp core install --path="/var/www/html" --allow-root --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ROOT_USER --admin_password=$WP_ROOT_PASSWORD --admin_email=$WP_ROOT_EMAIL --skip-email
	wp user create --path="/var/www/html" --allow-root $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD --role='contributor'
else
	echo "WordPress already installed, skipping installation."
fi

echo "Starting PHP-FPM 7.4"
exec php-fpm7.4 -F
