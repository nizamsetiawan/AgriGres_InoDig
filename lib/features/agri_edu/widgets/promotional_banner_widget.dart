import 'package:flutter/material.dart';

class PromotionalBannerWidget extends StatelessWidget {
  const PromotionalBannerWidget({Key? key}) : super(key: key);

  // Informasi lengkap tentang fitur-fitur AgriGres
  static final List<Map<String, dynamic>> _bannerData = [
    {
      'title': 'Deteksi Penyakit Tanaman dengan AI',
      'subtitle': 'Gunakan kamera untuk mendiagnosis penyakit daun jagung, tomat, dan singkong dengan akurasi tinggi menggunakan teknologi machine learning.',
      'buttonText': 'Mulai Deteksi',
      'icon': Icons.agriculture,
      'backgroundColor': Colors.green[50],
      'buttonColor': Colors.orange,
      'iconColor': Colors.green[600],
      'features': ['AI Detection', 'Multi-Crop', 'Real-time'],
    },
    {
      'title': 'AgriEdu - Sekolah Tani Digital',
      'subtitle': 'Akses ribuan video tutorial pertanian, panduan budidaya, dan tips dari para ahli untuk meningkatkan hasil panen Anda.',
      'buttonText': 'Mulai Belajar',
      'icon': Icons.school,
      'backgroundColor': Colors.blue[50],
      'buttonColor': Colors.blue,
      'iconColor': Colors.blue[600],
      'features': ['Video Tutorial', 'Expert Tips', 'Latest Techniques'],
    },
    {
      'title': 'AgriInfo - Harga Pangan Harian',
      'subtitle': 'Pantau harga komoditas pertanian terkini, analisis tren pasar, dan dapatkan informasi harga terbaik untuk hasil panen Anda.',
      'buttonText': 'Lihat Harga',
      'icon': Icons.trending_up,
      'backgroundColor': Colors.purple[50],
      'buttonColor': Colors.purple,
      'iconColor': Colors.purple[600],
      'features': ['Real-time Price', 'Market Analysis', 'Price Alerts'],
    },
    {
      'title': 'AgriCare - Deteksi Hama & Penyakit',
      'subtitle': 'Identifikasi hama dan penyakit tanaman secara instan dengan teknologi AI. Dapatkan solusi pengendalian yang tepat dan efektif.',
      'buttonText': 'Deteksi Sekarang',
      'icon': Icons.bug_report,
      'backgroundColor': Colors.red[50],
      'buttonColor': Colors.red,
      'iconColor': Colors.red[600],
      'features': ['Pest Detection', 'Disease ID', 'Control Solutions'],
    },
    {
      'title': 'AgriMart - Marketplace Pertanian',
      'subtitle': 'Jual beli hasil pertanian, benih, pupuk, dan alat pertanian dengan mudah. Terhubung langsung dengan pembeli dan penjual terpercaya.',
      'buttonText': 'Jelajahi Pasar',
      'icon': Icons.store,
      'backgroundColor': Colors.orange[50],
      'buttonColor': Colors.orange,
      'iconColor': Colors.orange[600],
      'features': ['Buy & Sell', 'Trusted Sellers', 'Secure Payment'],
    },
    {
      'title': 'Kalkulator Pertanian',
      'subtitle': 'Hitung kebutuhan pupuk, benih, dan biaya produksi dengan kalkulator pertanian yang akurat untuk optimasi hasil panen.',
      'buttonText': 'Hitung Sekarang',
      'icon': Icons.calculate,
      'backgroundColor': Colors.cyan[50],
      'buttonColor': Colors.cyan,
      'iconColor': Colors.cyan[600],
      'features': ['Fertilizer Calc', 'Cost Analysis', 'Yield Optimization'],
    },
    {
      'title': 'Forum Komunitas Petani',
      'subtitle': 'Bergabung dengan komunitas petani, berbagi pengalaman, bertanya pada ahli, dan dapatkan tips dari sesama petani.',
      'buttonText': 'Bergabung',
      'icon': Icons.forum,
      'backgroundColor': Colors.teal[50],
      'buttonColor': Colors.teal,
      'iconColor': Colors.teal[600],
      'features': ['Community', 'Expert Q&A', 'Experience Sharing'],
    },
    {
      'title': 'Panduan Budidaya Lengkap',
      'subtitle': 'Akses panduan budidaya step-by-step untuk berbagai tanaman, dari persiapan lahan hingga pascapanen dengan detail lengkap.',
      'buttonText': 'Lihat Panduan',
      'icon': Icons.menu_book,
      'backgroundColor': Colors.indigo[50],
      'buttonColor': Colors.indigo,
      'iconColor': Colors.indigo[600],
      'features': ['Step-by-step', 'Multi-Crop', 'Seasonal Guide'],
    },
    {
      'title': 'Weather & Climate Info',
      'subtitle': 'Pantau cuaca dan iklim terkini untuk perencanaan tanam yang optimal. Dapatkan prediksi cuaca dan rekomendasi waktu tanam.',
      'buttonText': 'Lihat Cuaca',
      'icon': Icons.wb_sunny,
      'backgroundColor': Colors.amber[50],
      'buttonColor': Colors.amber[600],
      'iconColor': Colors.amber[600],
      'features': ['Weather Forecast', 'Climate Data', 'Planting Calendar'],
    },
    {
      'title': 'Riwayat Deteksi & Analisis',
      'subtitle': 'Simpan dan kelola riwayat deteksi penyakit, analisis hasil panen, dan pantau perkembangan tanaman dari waktu ke waktu.',
      'buttonText': 'Lihat Riwayat',
      'icon': Icons.history,
      'backgroundColor': Colors.grey[50],
      'buttonColor': Colors.grey[700],
      'iconColor': Colors.grey[600],
      'features': ['Detection History', 'Progress Tracking', 'Data Analytics'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _bannerData.length,
          itemBuilder: (context, index) {
            final banner = _bannerData[index];
            return Padding(
              padding: EdgeInsets.only(
                right: index < _bannerData.length - 1 ? 12 : 0,
              ),
              child: _buildBannerCard(context, textTheme, banner),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context, TextTheme textTheme, Map<String, dynamic> banner) {
    // Null safety untuk semua field
    final String title = banner['title'] ?? 'Judul tidak tersedia';
    final String subtitle = banner['subtitle'] ?? 'Deskripsi tidak tersedia';
    final String buttonText = banner['buttonText'] ?? 'Klik';
    final IconData icon = banner['icon'] as IconData? ?? Icons.help_outline;
    final Color backgroundColor = banner['backgroundColor'] as Color? ?? Colors.grey[50]!;
    final Color buttonColor = banner['buttonColor'] as Color? ?? Colors.blue;
    final Color iconColor = banner['iconColor'] as Color? ?? Colors.grey[600]!;
    final List<String> features = (banner['features'] as List<dynamic>?)?.cast<String>() ?? [];

    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header dengan icon dan title
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Subtitle/Description
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontSize: 10,
              height: 1.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          
          // Features tags
          if (features.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: features.take(2).map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: iconColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    feature,
                    style: textTheme.bodySmall?.copyWith(
                      color: iconColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 8),
          
          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to specific feature
                _handleButtonPress(context, title);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                side: BorderSide(color: buttonColor),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size(0, 28),
              ),
              child: Text(
                buttonText,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(BuildContext context, String title) {
    // Navigation logic berdasarkan title
    switch (title) {
      case 'Deteksi Penyakit Tanaman dengan AI':
        // Navigate to detection screen
        break;
      case 'AgriEdu - Sekolah Tani Digital':
        // Navigate to AgriEdu screen
        break;
      case 'AgriInfo - Harga Pangan Harian':
        // Navigate to AgriInfo screen
        break;
      case 'AgriCare - Deteksi Hama & Penyakit':
        // Navigate to AgriCare screen
        break;
      case 'AgriMart - Marketplace Pertanian':
        // Navigate to AgriMart screen
        break;
      case 'Kalkulator Pertanian':
        // Navigate to Calculator screen
        break;
      case 'Forum Komunitas Petani':
        // Navigate to Forum screen
        break;
      case 'Panduan Budidaya Lengkap':
        // Navigate to Guide screen
        break;
      case 'Weather & Climate Info':
        // Navigate to Weather screen
        break;
      case 'Riwayat Deteksi & Analisis':
        // Navigate to History screen
        break;
      default:
        // Default action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fitur $title akan segera tersedia'),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }
}
