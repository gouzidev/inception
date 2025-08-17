from alpine:3.21

# tools first (alpine is minimal)
run apk add --no-cache wget tar  curl zsh



#installing php and php-fpm
run apk add --no-cache php php-fpm php-mysqli php-pdo php-pdo_mysql php-json php-curl php-gd php-zip php-xml php-mbstring php-session php-fileinfo php-tokenizer 

run apk add --no-cache mariadb-client


# Configure php-fpm to listen on port 9000
copy conf/php-fpm.conf /etc/php83/php-fpm.d/www.conf


copy conf/wp-config.php /tmp/wp-config.php


copy tools/start.sh ./script.sh

# this will run it not as shell (exec mode not shell mode) so it will get pid 1
entrypoint ./script.sh