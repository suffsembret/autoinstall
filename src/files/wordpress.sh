#!/bin/bash

# Update package lists and install required packages
echo "Updating and installing required packages..."
apt update && apt install -y apache2 php mariadb-server phpmyadmin wget unzip

# Download WordPress
WORDPRESS_ZIP_URL="http://172.16.90.2/unduh/wordpress.zip"
echo "Downloading WordPress from $WORDPRESS_ZIP_URL..."
wget -O wordpress.zip $WORDPRESS_ZIP_URL

# Move WordPress to the web directory
echo "Moving WordPress to /var/www/html..."
mv wordpress.zip /var/www/html/
cd /var/www/html/

# Check contents and proceed
echo "Unzipping WordPress..."
unzip wordpress.zip

# Remove default index.html if exists
echo "Removing default index.html..."
rm -f index.html

# Move WordPress files to the root of the web directory
echo "Organizing WordPress files..."
cd wordpress
mv * ../
cd ..
rm -rf wordpress

# Set permissions
echo "Setting permissions for /var/www/html..."
chmod -R 777 /var/www/html/

# Secure MySQL installation
echo "Securing MySQL installation..."
mysql_secure_installation <<EOF
n
123
123
y
y
y
y
EOF

# Create WordPress database
echo "Creating WordPress database..."
mysql -u root -p123 <<EOF
CREATE DATABASE wordpress;
EXIT;
EOF

# Final instructions
echo "WordPress setup is complete. Open your browser and navigate to the server's IP address."
echo "Complete the WordPress setup wizard with the following details:"
echo "Database Name: wordpress"
echo "Database User: root"
echo "Database Password: 123"
echo "Database Host: localhost"
echo "--- Site Details ---"
echo "Site Title: Website"
echo "Username: sufyan"
echo "Password: bebas"
echo "Email: admin@admin.net"

# Restart Apache2 to apply changes
echo "Restarting Apache2..."
systemctl restart apache2

# Done
echo "WordPress installation script completed successfully!"
