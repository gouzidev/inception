CREATE DATABASE IF NOT EXISTS wordpress;

-- Create user with full privileges
CREATE USER IF NOT EXISTS 'sgouzi'@'%' IDENTIFIED BY 'password';
CREATE USER IF NOT EXISTS 'salah'@'localhost' IDENTIFIED BY 'password';

-- Grant privileges
GRANT ALL PRIVILEGES ON wordpress.* TO 'sgouzi'@'%' WITH GRANT OPTION;

-- Allow root login from any host
UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root' AND Host='localhost';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Flush privileges to ensure changes take effect
FLUSH PRIVILEGES;