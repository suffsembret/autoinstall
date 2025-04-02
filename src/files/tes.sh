#!/bin/bash

# Memastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan sebagai root."
  exit
fi

# Update dan instalasi paket yang diperlukan
echo "Menginstal paket yang diperlukan..."
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password yourpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password yourpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password yourpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

apt update && apt install openssh-server apache2 php mariadb-server phpmyadmin wget unzip -y

# Meminta pengguna memasukkan password satu kali untuk phpMyAdmin dan WordPress
read -sp "Masukkan password untuk phpMyAdmin dan WordPress: " user_password
echo ""

# Konfigurasi phpMyAdmin
mysql -u root -e "ALTER USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$user_password';"

# Meminta pengguna memasukkan nama database
read -p "Masukkan nama database yang ingin dibuat: " dbname
read -p "Masukkan username untuk database: " dbuser

echo "\nMembuat database dan user..."
mysql -u root -p <<EOF
CREATE DATABASE $dbname;
CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$user_password';
GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Database '$dbname' dan user '$dbuser' berhasil dibuat."

# Unduh dan ekstrak WordPress
echo "Mengunduh dan mengekstrak WordPress..."
cd /var/www/html
wget http://172.16.90.2/unduh/wordpress.zip
unzip wordpress.zip
chmod -R 777 wordpress

# Konfigurasi database untuk WordPress
echo "Membuat konfigurasi WordPress..."
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sed -i "s/database_name_here/$dbname/" wordpress/wp-config.php
sed -i "s/username_here/$dbuser/" wordpress/wp-config.php
sed -i "s/password_here/$user_password/" wordpress/wp-config.php

# Restart layanan Apache untuk memastikan semua berjalan
echo "Restart layanan Apache..."
systemctl restart apache2

# Mendapatkan alamat IP server
server_ip=$(hostname -I | awk '{print $1}')

# Informasi akhir
echo -e "\e[32mInstalasi selesai!\e[0m"
echo -e "Akses phpMyAdmin di: \e[32mhttp://$server_ip/phpmyadmin\e[0m"
echo -e "Akses WordPress di: \e[32mhttp://$server_ip/wordpress\e[0m"
