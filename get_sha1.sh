#!/bin/bash

# Script untuk mendapatkan SHA-1 fingerprint dari production keystore
# Usage: ./get_sha1.sh

echo "🔑 Mendapatkan SHA-1 fingerprint dari production keystore..."
echo ""

KEYSTORE_PATH="android/app/agrigres-keystore.jks"
KEY_ALIAS="agrigres"

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "❌ Error: Keystore file tidak ditemukan di $KEYSTORE_PATH"
    exit 1
fi

echo "📋 Keystore: $KEYSTORE_PATH"
echo "📋 Alias: $KEY_ALIAS"
echo ""
echo "🔐 Masukkan password keystore (default: 123456)"
echo ""

keytool -list -v -keystore "$KEYSTORE_PATH" -alias "$KEY_ALIAS" | grep -A 2 "Certificate fingerprints"

echo ""
echo "✅ Copy SHA-1 fingerprint di atas (format: XX:XX:XX:...) dan tambahkan ke Firebase Console"
echo "📖 Lihat GOOGLE_SIGNIN_SETUP.md untuk instruksi lengkap"

