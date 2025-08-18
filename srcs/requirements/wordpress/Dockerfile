FROM alpine:3.21.4

# tools first (alpine is minimal)
RUN apk add --no-cache wget tar  curl zsh



#installing php and php-fpm
RUN apk add --no-cache php php-fpm php-mysqli php-pdo php-pdo_mysql php-json php-curl php-gd php-zip php-xml php-mbstring php-session php-fileinfo php-tokenizer 

RUN apk add --no-cache mariadb-client


# Configure php-fpm to listen on port 9000
COPY conf/php-fpm.conf /etc/php83/php-fpm.d/www.conf


COPY conf/wp-config.php /tmp/wp-config.php


COPY tools/start.sh ./script.sh

# this will RUN it not as shell (exec mode not shell mode) so it will get pid 1
ENTRYPOINT ./script.sh