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

# Mendapatkan alamat IP server
server_ip=$(hostname -I | awk '{print $1}')

# Informasi akhir
echo -e "\e[32mInstalasi selesai!\e[0m"
echo -e "Akses PhpMyAdmin Di Browser: \e[32mhttp://$server_ip/phpmyadmin\e[0m"
echo -e "Akses WordPress Di Browser: \e[32mhttp://$server_ip/wordpress\e[0m"

echo -e "\e[32m"

echo -e "\e[35m===============================\e[0m"
echo -e "\e[35m    Script by Sufsembret    \e[0m"
echo -e "\e[35m===============================\e[0m"

# Membuka alamat IP server secara otomatis jika dalam lingkungan grafis
if command -v xdg-open &> /dev/null; then
  xdg-open "http://$server_ip/wordpress"
elif command -v gnome-open &> /dev/null; then
  gnome-open "http://$server_ip/wordpress"
elif command -v sensible-browser &> /dev/null; then
  sensible-browser "http://$server_ip/wordpress"
fi
