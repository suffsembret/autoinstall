#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
    echo "Harap jalankan script ini sebagai root atau gunakan sudo."
    exit 1
fi

echo "🔄 Memperbarui dan meng-upgrade sistem..."
apt update && apt upgrade -y

echo "📦 Menginstal paket yang diperlukan..."
apt install -y wget git ffmpeg nodejs npm curl nano

# Instal Yarn jika belum ada
if ! command -v yarn &> /dev/null; then
    echo "📦 Menginstal Yarn..."
    npm install -g yarn
fi

# Menyiapkan folder proyek
PROJECT_DIR="/root/nama-folder"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Membuat package.json jika belum ada
if [ ! -f "package.json" ]; then
    echo "📄 Membuat file package.json..."
    cat > package.json <<EOL
{
  "name": "nama-proyek",
  "version": "1.0.0",
  "description": "Proyek Node.js di Debian 11",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
EOL
fi

# Membuat index.js jika belum ada
if [ ! -f "index.js" ]; then
    echo "📄 Membuat file index.js..."
    cat > index.js <<EOL
console.log("✅ Server berjalan dengan sukses!");
EOL
fi

# Install dependencies dengan Yarn
echo "📦 Menginstal dependencies..."
yarn install

# Menjalankan aplikasi
echo "🚀 Menjalankan aplikasi..."
npm start
