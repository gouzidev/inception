#!/bin/sh
# tools/start.sh

set -e  # exit if any command fails

echo "🔧 wordpress: starting initialization..."

# create wordpress directory structure
mkdir -p /var/data/www

echo "wordpress downloading and extracting files..."

# installing wordpress to the right path
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
  && tar -xzf /tmp/wordpress.tar.gz -C /var/data/www/ \
  && rm /tmp/wordpress.tar.gz

echo "wordpress setting up configuration..."

# copy pre-configured wp-config.php
cp /tmp/wp-config.php /var/data/www/wordpress/wp-config.php

# clean up temporary files
rm /tmp/wp-config.php

echo "wordpress fixing ownership and permissions..."

# set proper ownership for web files
chown -R nobody:nobody /var/data/www/wordpress

echo "wordpress initialization complete..."

echo "starting php-fpm..."

# start php-fpm process, replaces curr shell
exec php-fpm83 -F