FROM debian:12

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y \
    wget \
    tar \
    curl \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod 777 ./wp-cli.phar

RUN mkdir -p /var/www/html

RUN chown -R www-data:www-data /var/www/html

RUN mv ./wp-cli.phar /usr/bin/wp

# Configure PHP-FPM
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf


COPY tools/script.sh /tmp/script.sh

RUN chmod 777 /tmp/script.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/tmp/script.sh"]