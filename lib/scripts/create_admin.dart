/// Script untuk membuat admin pertama di Firebase
/// 
/// Cara penggunaan:
/// 1. Buka Firebase Console
/// 2. Masuk ke Authentication > Users
/// 3. Tambahkan user baru dengan email dan password
/// 4. Masuk ke Firestore Database
/// 5. Buat collection baru dengan nama "Admins"
/// 6. Tambahkan document dengan ID = UID dari user yang baru dibuat
/// 7. Tambahkan fields berikut:
///    - Email: "admin@agrigres.com" (atau email yang Anda inginkan)
///    - Name: "Admin Utama"
///    - Role: "super_admin"
///    - CreatedAt: "2024-01-01T00:00:00.000Z" (atau timestamp sekarang)
///    - IsActive: true
/// 
/// Atau gunakan script ini di Dart console untuk membuat admin:
/// 
/// ```dart
/// import 'package:cloud_firestore/cloud_firestore.dart';
/// import 'package:firebase_auth/firebase_auth.dart';
/// 
/// Future<void> createAdmin() async {
///   final auth = FirebaseAuth.instance;
///   final db = FirebaseFirestore.instance;
///   
///   // Buat user di Firebase Auth
///   final userCredential = await auth.createUserWithEmailAndPassword(
///     email: 'admin@agrigres.com',
///     password: 'Admin123!', // Ganti dengan password yang kuat
///   );
///   
///   // Buat document di Firestore
///   await db.collection('Admins').doc(userCredential.user!.uid).set({
///     'Email': 'admin@agrigres.com',
///     'Name': 'Admin Utama',
///     'Role': 'super_admin',
///     'CreatedAt': DateTime.now().toIso8601String(),
///     'IsActive': true,
///   });
///   
///   print('Admin berhasil dibuat!');
/// }
/// ```

/// Default Admin Credentials (untuk development):
/// Email: admin@agrigres.com
/// Password: Admin123!
/// 
/// PENTING: Ganti password ini di production!

