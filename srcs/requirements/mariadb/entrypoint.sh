#!/bin/bash
set -e

# Clear any existing data to avoid version compatibility issues
if [ -d "/var/lib/mysql" ]; then
  echo "Clearing existing MariaDB data directory to avoid version conflicts..."
  rm -rf /var/lib/mysql/*
fi

# Ensure proper directory structure
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Initialize a fresh database
echo "Initializing new MariaDB database..."
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Start MariaDB server temporarily
echo "Starting temporary MariaDB server..."
mysqld --user=mysql --skip-networking &
pid="$!"

# Wait for MariaDB to become available
until mysqladmin ping -h localhost --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# Run initialization script
echo "Running initialization script..."

mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Shutdown temporary server
echo "Shutting down temporary server..."
mysqladmin shutdown

# Start MariaDB in foreground
echo "Starting MariaDB server..."
exec mysqld --user=mysql