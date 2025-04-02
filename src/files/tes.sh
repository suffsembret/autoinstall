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

# Konfigurasi phpMyAdmin
read -p "Masukkan password untuk phpMyAdmin: " phpmyadmin_password
mysql -u root -e "ALTER USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$phpmyadmin_password';"

# Meminta pengguna memasukkan nama database
read -p "Masukkan nama database yang ingin dibuat: " dbname
read -p "Masukkan username untuk database: " dbuser
read -sp "Masukkan password untuk user database: " dbpass

echo "\nMembuat database dan user..."
mysql -u root -p <<EOF
CREATE DATABASE $dbname;
CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';
GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "Database '$dbname' dan user '$dbuser' berhasil dibuat."

# Restart layanan Apache untuk memastikan semua berjalan
echo "Restart layanan Apache..."
systemctl restart apache2

# Mendapatkan alamat IP server
server_ip=$(hostname -I | awk '{print $1}')

# Informasi akhir
echo -e "\e[32mInstalasi selesai!\e[0m"
echo -e "Akses phpMyAdmin di: \e[32mhttp://$server_ip/phpmyadmin\e[0m"
