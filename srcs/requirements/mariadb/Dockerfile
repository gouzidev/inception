from alpine:3.21


# tools first (alpine is minimal)
run apk add --no-cache wget tar  curl zsh 

# download mariadb
run apk add mariadb mariadb-client

# prepare needed folders for maria
run mkdir -p /var/lib/mysql /run/mysqld

run chown -R mysql:mysql /var/lib/mysql /run/mysqld



# copy config file
copy conf/db.cnf /etc/my.cnf


# copy init script file
copy tools/init.sh /usr/local/bin

entrypoint ["/usr/local/bin/init.sh"]