mkdir -p /var/data/www

# installing wordpress to its right path
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
  && tar -xzf /tmp/wordpress.tar.gz -C /var/data/www/ \
  && rm /tmp/wordpress.tar.gz

cp /tmp/wp-config.php /var/data/www/wordpress/wp-config.php

rm /tmp/wp-config.php

chown -R nobody:nobody /var/data/www/wordpress


echo "starting php-fpm..."

exec php-fpm83 -F