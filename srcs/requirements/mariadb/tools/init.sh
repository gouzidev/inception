#!/bin/sh
# tools/init.sh

set -e  # exit if any command fails

# get environment variables (with defaults)
MARIADB_ADMIN_PASSWORD="${MARIADB_ADMIN_PASSWORD}"
MARIADB_DATABASE="${MARIADB_DATABASE}"

MARIADB_USER_USERNAME="${MARIADB_USER_USERNAME}"
MARIADB_USER_PASSWORD="${MARIADB_USER_PASSWORD}"

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

echo "mariadb: Starting initialization..."


# fixing ownership
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# if first time, run this
if [ ! -d "$DATADIR/mysql" ]; then
    echo "mariadb first run, initializing database..."
    
    # init the database system
    # create the mysql, performance_schema, etc. databases
    mariadb-install-db \
        --user=mysql \
        --datadir="$DATADIR" \
        --skip-test-db
    
    echo "mariadb temporary server for setup starting..."
    
    # start mariadb temporarily (socket only, no network)
    mysqld --user=mysql --datadir="$DATADIR" --socket="$SOCKET" --skip-networking &
    TEMP_PID=$!
    
    # wait for mariadb to be ready, max of 30sec
    echo "mariadb waiting for server to be ready..."
    for i in $(seq 1 30); do
        if mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; then
            echo "mariadb server is ready"
            break
        fi
        sleep 1
    done
    
    # check if server actually started
    if ! mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; then
            echo "mariadb server failed"
        exit 1
    fi
    
    echo "mariadb running initializing SQL..."
    
    # setup db
    mysql --socket="$SOCKET" <<-EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ADMIN_PASSWORD';

-- Create root user for external connections
CREATE USER '$MARIADB_ADMIN_USERNAME'@'%' IDENTIFIED BY '$MARIADB_ADMIN_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$MARIADB_ADMIN_USERNAME'@'%' WITH GRANT OPTION;

-- Create application database
CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\` 
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create application user
CREATE USER '$MARIADB_USER_USERNAME'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MARIADB_DATABASE\`.* TO '$MARIADB_USER_USERNAME'@'%';

-- Apply changes
FLUSH PRIVILEGES;
EOF
    echo "mariadb shutting down temporary server..."
    mysqladmin --socket="$SOCKET" --password="$MARIADB_ADMIN_PASSWORD" shutdown
    wait $TEMP_PID
    
    echo "mariadb initialization complete..."
else
    echo "mariadb database already exists, skipping initialization"
fi

echo  "starting mariadb..."

# start maria process, replaces curr shell
exec mysqld --user=mysql --datadir="$DATADIR" --socket="$SOCKET" --bind-address="0.0.0.0"