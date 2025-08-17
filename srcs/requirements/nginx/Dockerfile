from alpine:3.21


# tools first (alpine is minimal)
run apk add --no-cache openssl zsh curl bash


#install nginx
run apk add --no-cache nginx


# setup certificate
run mkdir -p /etc/nginx/ssl

run openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=sgouzi.42.fr" \
    -addext "subjectAltName=DNS:sgouzi.42.fr,DNS:localhost,IP:127.0.0.1"

run chmod 600 /etc/nginx/ssl/nginx.key

run chmod 644 /etc/nginx/ssl/nginx.crt



copy tools/conf.conf /etc/nginx/nginx.conf
# copy the config file from host to the container for nginx to use it


# run it as entry point (exec mode)
entrypoint ["nginx", "-g", "daemon off;"]