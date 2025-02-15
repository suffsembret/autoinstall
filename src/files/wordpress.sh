#!/bin/bash

# Memastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan sebagai root."
  exit
fi

# Update dan instalasi paket yang diperlukan
echo "Menginstal paket yang diperlukan..."
apt update && apt install openssh-server apache2 php mariadb-server phpmyadmin wget unzip -y

# Konfigurasi phpMyAdmin
read -p "Masukkan password untuk phpMyAdmin: " phpmyadmin_password
mysql -u root -e "ALTER USER 'phpmyadmin'@'localhost' IDENTIFIED BY '$phpmyadmin_password';"

# Konfigurasi SSH untuk mengizinkan login root
echo "Mengonfigurasi SSH untuk login root..."
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Unduh dan ekstrak WordPress
echo "Mengunduh dan mengekstrak WordPress..."
cd /var/www/html
wget http://172.16.90.2/unduh/wordpress.zip
unzip wordpress.zip
chmod -R 777 wordpress

# Konfigurasi database untuk WordPress
echo "Membuat database untuk WordPress..."
mysql -u root -p <<EOF
CREATE DATABASE dbwordpress;
CREATE USER 'adminwordpress'@'localhost' IDENTIFIED BY 'passwordwordpress';
GRANT ALL PRIVILEGES ON dbwordpress.* TO 'adminwordpress'@'localhost';
FLUSH PRIVILEGES;
EOF

# Restart layanan Apache untuk memastikan semua berjalan
echo "Restart layanan Apache..."
systemctl restart apache2

echo "Proses instalasi WordPress selesai!"
echo "Anda dapat melanjutkan konfigurasi melalui browser."
