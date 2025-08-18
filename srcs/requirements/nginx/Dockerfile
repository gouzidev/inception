FROM alpine:3.21.4


# tools first (alpine is minimal)
RUN apk add --no-cache openssl zsh curl bash


#install nginx
RUN apk add --no-cache nginx



# setup certificate
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=sgouzi.42.fr" \
    -addext "subjectAltName=DNS:sgouzi.42.fr,DNS:localhost,IP:127.0.0.1"

RUN chmod 600 /etc/nginx/ssl/nginx.key

RUN chmod 644 /etc/nginx/ssl/nginx.crt



COPY conf/conf.conf /etc/nginx/nginx.conf
# COPY the config file FROM host to the container for nginx to use it

RUN echo "starting nginx..."

# RUN it as entry point (exec mode)
ENTRYPOINT ["nginx", "-g", "daemon off;"]