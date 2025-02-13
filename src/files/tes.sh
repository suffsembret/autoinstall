#!/bin/bash
# Variabel warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'  # Warna biru muda
RESET='\033[0m'

# Pesan pembuka
echo -e "${GREEN}Memulai instalasi WordPress...${RESET}"

# Mengatur nama database, username, dan password secara otomatis
DB_NAME="dbwordpress"
DB_USER="adminwordpress"
DB_PASS="passwordwordpress"  # Anda bisa mengganti password sesuai kebutuhan

# Menambahkan repository global Debian 11 (Bullseye)
echo -e "${YELLOW}Menambahkan repository global Debian 11 (Bullseye)...${RESET}"
cat <<EOF | tee /etc/apt/sources.list
# Debian 11 Bullseye - Main Repository
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

# Debian 11 Bullseye - Security Updates
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

# Debian 11 Bullseye - Updates
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free

# Debian 11 Bullseye - Backports (Optional)
deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free
EOF

# Update dan instal paket yang diperlukan
echo -e "${YELLOW}Mengupdate dan menginstal paket yang diperlukan...${RESET}"
apt update && apt install openssh-server apache2 php mariadb-server phpmyadmin wget unzip -y

# Konfigurasi MySQL (MariaDB)
echo -e "${YELLOW}Mengkonfigurasi database...${RESET}"
mysql -e "CREATE DATABASE ${DB_NAME};"
mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Unduh dan ekstrak WordPress
echo -e "${YELLOW}Mengunduh dan mengekstrak WordPress...${RESET}"
wget -q http://172.16.90.2/unduh/wordpress.zip
unzip wordpress.zip -d /var/www/html/
rm wordpress.zip

# Konfigurasi wp-config.php
echo -e "${YELLOW}Mengkonfigurasi wp-config.php...${RESET}"
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${DB_PASS}/" /var/www/html/wordpress/wp-config.php

# Setel izin yang sesuai
echo -e "${YELLOW}Mengatur izin file...${RESET}"
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Restart layanan
echo -e "${YELLOW}Merestart layanan...${RESET}"
systemctl restart apache2
systemctl restart mariadb

# Pesan penutup

echo -e "${GREEN}Instalasi WordPress selesai!${RESET}"
echo -e "Akses melalui browser dengan membuka: http://$(hostname -I | awk '{print $1}')/wordpress"
echo -e "${CYAN}Script by IG @sufsembret_${RESET}"
