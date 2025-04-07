FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt install -y \
    nginx \
    openssl \
    curl \
    php-fpm

RUN mkdir /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=MA/ST=Sale/L=Sale/O=1337/CN=localhost"

# Ensure www directory exists and has correct permissions
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]