FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Ensure proper directories and permissions
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Configure MariaDB to allow external connections
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY tools/init.sql /tmp/init.sql

# Ensure correct permissions for init script
RUN chmod 644 /tmp/init.sql \
    && chown mysql:mysql /tmp/init.sql

# Expose MariaDB port
EXPOSE 3306

# Use an entrypoint script to ensure initialization
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]