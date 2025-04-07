#!/bin/bash

mkdir -p /run/php

cd /var/www/html

# Only download WordPress if not already present
if [ ! -f "wp-config.php" ]; then
    # Wait for MariaDB to be ready
    until mysqladmin ping -h"$DB_HOST" --silent; do
        echo "Waiting for database connection..."
        sleep 2
    done
    
    wp core download --allow-root
    
    wp config create --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --dbcharset="utf8"
    
    wp core install --allow-root \
        --url="$WP_URL" \
        --title="Inception" \
        --admin_user="$DB_USER" \
        --admin_password="$DB_PASSWORD" \
        --admin_email="salahgouzi11@gmail.com"
    
    echo "WordPress installation completed."
else
    echo "WordPress already installed. Skipping installation."
fi

echo "Starting PHP-FPM..."
php-fpm8.2 -F