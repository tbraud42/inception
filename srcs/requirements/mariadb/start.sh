#!/bin/sh

set -e

echo "MariaDB  initialization"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ] || [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1

    mysqld_safe --user=mysql --port=3307 &

    i=0
    while ! mysqladmin ping -P 3307 --silent > /dev/null 2>&1; do
        i=$((i + 1))
        if [ "$i" -ge 10 ]; then
            echo "runtime error: mariadb did not start correctly"
            exit 1
        fi
        sleep 0.1
    done

    if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        echo "missing error: missing variable"
        mysqladmin -P 3307 -u root shutdown > /dev/null 2>&1
        exit 1
    fi

    printf "init '$MYSQL_DATABASE'\n"

    mysql -P 3307 -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    mysqladmin -P 3307 -u root shutdown > /dev/null 2>&1
fi

exec mysqld --user=mysql --bind-address=0.0.0.0
