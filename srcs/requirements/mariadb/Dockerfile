FROM alpine:3.21.4


# tools first (alpine is minimal)
RUN apk add --no-cache wget tar  curl zsh 

# download mariadb
RUN apk add mariadb mariadb-client

# prepare needed folders for maria
RUN mkdir -p /var/lib/mysql /run/mysqld

RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld



# COPY config file
COPY conf/db.cnf /etc/my.cnf


# COPY init script file
COPY tools/init.sh /usr/local/bin

ENTRYPOINT ["/usr/local/bin/init.sh"]