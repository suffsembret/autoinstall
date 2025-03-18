#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
    echo "Harap jalankan script ini sebagai root atau gunakan sudo."
    exit 1
fi

echo "Memperbarui dan meng-upgrade sistem..."
apt update && apt upgrade -y

echo "Menginstal paket yang diperlukan..."
apt install -y wget git ffmpeg nodejs npm curl

# Instal Yarn jika belum ada
if ! command -v yarn &> /dev/null; then
    echo "Menginstal Yarn..."
    npm install -g yarn
fi

# Membuat folder proyek
PROJECT_DIR="/root/nama-folder"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Inisialisasi proyek Node.js jika belum ada
if [ ! -f "package.json" ]; then
    echo "Membuat file package.json..."
    npm init -y
fi

# Install dependencies dengan Yarn
echo "Menginstal dependencies..."
yarn install

# Menjalankan aplikasi
echo "Menjalankan aplikasi..."
npm start
