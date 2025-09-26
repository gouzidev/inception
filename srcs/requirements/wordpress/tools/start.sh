#!/bin/sh
# tools/start.sh

WP_PATH=/var/data/www/wordpress

set -e  # exit if any command fails

echo "🔧 wordpress: starting initialization..."


if [ ! -f "$WP_PATH/wp-admin/index.php" ]; then

  # create wordpress directory structure
  mkdir -p /var/data/www

  echo "wordpress downloading and extracting files..."
  
  # installing wordpress to the right path
  wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/data/www/ \
    && rm /tmp/wordpress.tar.gz


  # copy pre-configured wp-config.php

  # clean up temporary files
  cp /tmp/wp-config.php $WP_PATH/wp-config.php
  
  rm /tmp/wp-config.php
  
  echo "wordpress fixing ownership and permissions..."
  
  # set proper ownership for web files
  chown -R nobody:nobody $WP_PATH
  
  echo "wordpress initialization complete..."

else
  echo "wordpress is already setup..."
fi

# install WP-CLI if not installed
if ! command -v wp >/dev/null 2>&1; then
  curl -sSLO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
fi


echo "waiting for mariadb at $WORDPRESS_DB_HOST:$WORDPRESS_DB_PORT ..."
for i in $(seq 1 30); do
  mysqladmin ping -h"$WORDPRESS_DB_HOST" -P"$WORDPRESS_DB_PORT" -u"$MARIADB_USER_USERNAME" -p"$MARIADB_USER_PASSWORD" >/dev/null 2>&1 && break
  sleep 1
done


# install core once mariadb init already created db
if ! wp core is-installed --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
  wp core install \
    --path="$WP_PATH" --allow-root \
    --url="https://$DOMAIN_NAME" \
    --title="Inception" \
    --admin_user="$WORDPRESS_ADMIN_NAME" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email

    # create non-admin user only if missing
    if ! wp user exists "$WORDPRESS_USER_NAME" --path="$WP_PATH" --allow-root; then
      wp user create "$WORDPRESS_USER_NAME" "$WORDPRESS_USER_EMAIL" \
        --user_pass="$WORDPRESS_USER_PASSWORD" --path="$WP_PATH" --allow-root
    else
      echo "WP not installed yet; skipping user creation."
    fi
fi


echo "starting php-fpm..."

# start php-fpm process, replaces curr shell
exec php-fpm83 -F