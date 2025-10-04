import 'package:flutter/material.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';

class PrivacyAndSecurityPage extends StatelessWidget {
  const PrivacyAndSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TAppBar(
        title: Text("Privasi dan Keamanan"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColors.primary.withOpacity(0.1),
                      TColors.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: TColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Privasi & Keamanan Data',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kami berkomitmen melindungi privasi dan keamanan data pribadi Anda',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Privacy Policy Card
              _buildInfoCard(
                context,
                Icons.policy,
                'Kebijakan Privasi',
                'Data pribadi Anda dilindungi sesuai dengan standar internasional. Kami hanya mengumpulkan data yang diperlukan untuk memberikan layanan terbaik.',
                TColors.primary,
              ),
              
              const SizedBox(height: 16),
              
              // Data Collection Card
              _buildInfoCard(
                context,
                Icons.data_usage,
                'Pengumpulan Data',
                'Kami mengumpulkan data foto tanaman, informasi profil, dan riwayat deteksi untuk meningkatkan akurasi diagnosis dan memberikan rekomendasi yang lebih baik.',
                Colors.blue,
              ),
              
              const SizedBox(height: 16),
              
              // Data Protection Card
              _buildInfoCard(
                context,
                Icons.shield,
                'Perlindungan Data',
                'Semua data dienkripsi menggunakan teknologi SSL/TLS dan disimpan di server yang aman. Data tidak akan dibagikan kepada pihak ketiga tanpa persetujuan Anda.',
                Colors.green,
              ),
              
              const SizedBox(height: 16),
              
              // User Control Card
              _buildInfoCard(
                context,
                Icons.settings,
                'Kontrol Pengguna',
                'Anda dapat mengakses, mengubah, atau menghapus data pribadi Anda kapan saja melalui pengaturan profil di aplikasi.',
                Colors.orange,
              ),
              
              const SizedBox(height: 16),
              
              // Security Features Card
              _buildInfoCard(
                context,
                Icons.verified_user,
                'Fitur Keamanan',
                'Aplikasi dilengkapi dengan autentikasi dua faktor, enkripsi end-to-end, dan monitoring keamanan 24/7 untuk melindungi akun Anda.',
                Colors.red,
              ),
              
              const SizedBox(height: 24),
              
              // Contact Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.contact_support,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pertanyaan Privasi?',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hubungi tim kami di privacy@agrigres.com untuk pertanyaan terkait privasi dan keamanan data.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'privacy@agrigres.com',
                        style: textTheme.bodySmall?.copyWith(
                          color: TColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
