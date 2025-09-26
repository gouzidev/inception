FROM alpine:3.21.0


# tools first (alpine is minimal)
RUN apk add --no-cache openssl zsh curl bash


#install nginx
RUN apk add --no-cache nginx



# setup certificate
RUN mkdir -p /etc/nginx/ssl

# installing openssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=sgouzi.42.fr" \
    -addext "subjectAltName=DNS:sgouzi.42.fr,DNS:localhost,IP:127.0.0.1"

# make sure the certfs are readable
RUN chmod 600 /etc/nginx/ssl/nginx.key

RUN chmod 644 /etc/nginx/ssl/nginx.crt



# copy the config file FROM host to the container for nginx to use it
COPY conf/conf.conf /etc/nginx/nginx.conf


RUN echo "starting nginx..."

# run it as entry point (exec mode) 
ENTRYPOINT ["nginx", "-g", "daemon off;"]