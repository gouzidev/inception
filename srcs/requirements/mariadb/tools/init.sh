#!/bin/sh
# tools/init.sh

set -e  # Exit if any command fails

# Get environment variables (with defaults)
MARIADB_ADMIN_PASSWORD="${MARIADB_ADMIN_PASSWORD}"
MARIADB_DATABASE="${MARIADB_DATABASE}"

MARIADB_USER_USERNAME="${MARIADB_USER_USERNAME}"
MARIADB_USER_PASSWORD="${MARIADB_USER_PASSWORD}"

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

echo "🔧 MariaDB: Starting initialization..."


# Ensure proper ownership
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Check if this is the first run
if [ ! -d "$DATADIR/mysql" ]; then
    echo "🏗️ MariaDB: First run detected, initializing database..."
    
    # Initialize the database system
    # This creates the mysql, performance_schema, etc. databases
    mariadb-install-db \
        --user=mysql \
        --datadir="$DATADIR" \
        --skip-test-db
    
    echo "🚀 MariaDB: Starting temporary server for setup..."
    
    # Start MariaDB temporarily (socket only, no network)
    mysqld --user=mysql --datadir="$DATADIR" --socket="$SOCKET" --skip-networking &
    TEMP_PID=$!
    
    # Wait for MariaDB to be ready
    echo "⏳ MariaDB: Waiting for server to be ready..."
    for i in $(seq 1 30); do
        if mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; then
            echo "✅ MariaDB: Server is ready!"
            break
        fi
        sleep 1
    done
    
    # Check if server actually started
    if ! mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; then
        echo "❌ MariaDB: Failed to start temporary server"
        exit 1
    fi
    
    echo "📝 MariaDB: Running initialization SQL..."
    
    # Run SQL commands to set up database
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


    echo "🛑 MariaDB: Shutting down temporary server..."
    mysqladmin --socket="$SOCKET" --password="$MARIADB_ADMIN_PASSWORD" shutdown
    wait $TEMP_PID
    
    echo "✅ MariaDB: Initialization complete!"
else
    echo "📂 MariaDB: Database already exists, skipping initialization"
fi

echo "🚀 MariaDB: Starting production server..."

# Start the actual MariaDB server (replaces this process)
exec mysqld --user=mysql --datadir="$DATADIR" --socket="$SOCKET" --bind-address="0.0.0.0"