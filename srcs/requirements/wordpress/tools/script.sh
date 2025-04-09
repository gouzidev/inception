#!/bin/bash

mkdir -p /run/php

cd /var/www/html

# Only download WordPress if not already present
if [ ! -f "wp-config.php" ]; then
    # Wait for MariaDB to be ready
    until mysqladmin ping -h"$MYSQL_DB_HOST" --silent; do
        echo "Waiting for database connection..."
        sleep 2
    done
    
    wp core download --allow-root
    
    wp config create --allow-root \
        --dbname="$MYSQL_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_DB_HOST" \
        --dbcharset="utf8"
    
    wp core install --allow-root \
        --url="$WP_URL" \
        --title="Inception" \
        --admin_user="$MYSQL_USER" \
        --admin_password="$MYSQL_PASSWORD" \
        --admin_email="salahgouzi11@gmail.com"
    
    echo "WordPress installation completed."
else
    echo "WordPress already installed. Skipping installation."
fi

echo "Starting PHP-FPM..."
php-fpm8.2 -F