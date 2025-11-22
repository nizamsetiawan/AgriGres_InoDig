# Setup Google Sign-In untuk Production APK

## 🔴 Masalah yang Sering Terjadi

Ketika aplikasi di-build sebagai **production APK** dan diinstall, Google Sign-In mungkin gagal dengan error:
- `sign_in_failed`
- `Gagal masuk. Silakan coba lagi.`

**Penyebab**: SHA-1 fingerprint dari **production keystore** belum terdaftar di Firebase Console.

> ⚠️ **Penting**: Debug keystore dan production keystore memiliki SHA-1 yang berbeda. Jika hanya debug SHA-1 yang terdaftar, production build akan gagal.

---

## 📋 Langkah-langkah Perbaikan

### 1. Dapatkan SHA-1 dari Production Keystore

#### Windows:
```bash
keytool -list -v -keystore android/app/agrigres-keystore.jks -alias agrigres
```

#### macOS/Linux:
```bash
keytool -list -v -keystore android/app/agrigres-keystore.jks -alias agrigres
```

**Password keystore**: `123456` (sesuai dengan `key.properties`)

#### Output yang dicari:
```
Certificate fingerprints:
     SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
     SHA256: XX:XX:XX:XX:...
```

**Salin SHA-1 fingerprint** (format: `XX:XX:XX:...`)

---

### 2. Tambahkan SHA-1 ke Firebase Console

> ⚠️ **PENTING**: **JANGAN HAPUS** SHA-1 yang sudah ada! SHA-1 debug dan production bisa terdaftar bersamaan. Anda hanya perlu **menambahkan** SHA-1 production baru.

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Klik ikon **⚙️ Settings** (di sidebar kiri) → **Project settings**
4. Scroll ke bagian **Your apps**
5. Pilih aplikasi Android Anda (package: `com.nizamsetiawan.agrigres`)
6. Klik **Add fingerprint** (jangan hapus yang sudah ada!)
7. Paste **SHA-1 fingerprint** dari production keystore
8. Klik **Save**

**Hasil akhir**: Anda akan memiliki **2 SHA-1 fingerprint**:
- ✅ SHA-1 Debug (untuk development/testing)
- ✅ SHA-1 Production (untuk release APK)

---

### 3. Download ulang google-services.json

Setelah menambahkan SHA-1:

1. Di halaman yang sama, klik **Download google-services.json**
2. **Ganti** file `android/app/google-services.json` dengan file yang baru
3. Pastikan file sudah ter-update

---

### 4. Rebuild APK

Setelah menambahkan SHA-1 dan update `google-services.json`:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

Atau untuk App Bundle:
```bash
flutter build appbundle --release
```

---

## 🔍 Verifikasi Setup

### Cek SHA-1 yang Terdaftar

1. Firebase Console → Project Settings → Your apps → Android app
2. Lihat bagian **SHA certificate fingerprints**
3. Pastikan ada **2 SHA-1** (keduanya harus ada):
   - ✅ **Debug keystore SHA-1** (untuk development/testing) - **JANGAN DIHAPUS**
   - ✅ **Production keystore SHA-1** (untuk release APK) - **TAMBAHKAN INI**

> 💡 **Tip**: Jika Anda menghapus SHA-1 debug, aplikasi tidak akan bisa login dengan Google saat development/debugging!

### Test di Device

1. Install APK production ke device
2. Coba login dengan Google Sign-In
3. Seharusnya berhasil tanpa error

---

## 🛠️ Troubleshooting

### Masih Error setelah Setup?

1. **Pastikan SHA-1 benar**:
   - Double-check SHA-1 yang di-copy
   - Pastikan menggunakan production keystore, bukan debug

2. **Pastikan google-services.json ter-update**:
   - Hapus `android/app/google-services.json`
   - Download ulang dari Firebase Console
   - Rebuild aplikasi

3. **Clear cache dan rebuild**:
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   flutter build apk --release
   ```

4. **Cek log untuk detail error**:
   - Error sekarang akan menampilkan pesan yang lebih jelas
   - Cek logcat untuk melihat error code spesifik

### Error Code Reference

- **Error 10** atau **sign_in_failed**: SHA-1 tidak terdaftar atau salah
- **Network error**: Masalah koneksi internet
- **User cancelled**: User membatalkan proses sign-in

---

## 📝 Catatan Penting

1. **Jangan share keystore file** (`agrigres-keystore.jks`) ke publik
2. **Simpan password keystore** dengan aman
3. **Setiap kali membuat keystore baru**, tambahkan SHA-1 baru ke Firebase
4. **Debug dan Production** memerlukan SHA-1 yang berbeda
5. **JANGAN HAPUS SHA-1 yang sudah ada** - tambahkan saja SHA-1 production baru
6. **Kedua SHA-1 bisa terdaftar bersamaan** - ini normal dan direkomendasikan

---

## ✅ Checklist

- [ ] SHA-1 dari production keystore sudah didapatkan
- [ ] SHA-1 sudah ditambahkan di Firebase Console
- [ ] `google-services.json` sudah di-download ulang dan di-replace
- [ ] Aplikasi sudah di-rebuild dengan `flutter build apk --release`
- [ ] APK sudah diinstall dan di-test di device
- [ ] Google Sign-In berhasil di production build

---

**Masih ada masalah?** Cek log error di aplikasi atau logcat untuk detail lebih lanjut.

