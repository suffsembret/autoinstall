sudo apt update && sudo apt upgrade -y
sudo apt install -y wget git ffmpeg nodejs npm yarn

# Pastikan storage tersedia (tidak diperlukan seperti di Termux, tetapi bisa disesuaikan)
mkdir -p ~/nama-folder
cd ~/nama-folder

# Instalasi dependensi menggunakan yarn
yarn install

# Menjalankan aplikasi
npm start
