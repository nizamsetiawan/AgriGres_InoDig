import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';

class AgriMartScreen extends StatelessWidget {
  const AgriMartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        showBackArrow: true,
        title: const Text('AgriMart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),
            
            const SizedBox(height: 16),
            
            // Marketplace Cards
            _buildMarketplaceCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Marketplace Resmi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Belanja hasil tani dan produk pertanian melalui marketplace resmi mitra AgriGresik.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketplaceCards() {
    return Column(
      children: [
        _buildMarketplaceCard(
          'Petromart Official Store',
          'Belanja dengan mudah & banyak promo.',
          'Shopee',
          Colors.green[50]!,
          Colors.green[600]!,
          Icons.shopping_bag_outlined,
          'https://shopee.co.id/petromartofficialstore',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Petromart Official Store',
          'Belanja dengan mudah & banyak prmo.',
          'Tokopedia',
          Colors.orange[50]!,
          Colors.orange[600]!,
          Icons.store_outlined,
          'https://www.tokopedia.com/petromartofficialstore',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Petromart Official Store',
          'Belanja dengan mudah & banyak promo.',
          'TikTok',
          Colors.purple[50]!,
          Colors.purple[600]!,
          Icons.video_call_outlined,
          'https://www.tiktok.com/@petromartofficial',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Tani Makmur Gresik',
          'Koperasi tani terpercaya dengan produk berkualitas.',
          'Shopee',
          Colors.lightGreen[50]!,
          Colors.lightGreen[600]!,
          Icons.eco_outlined,
          'https://shopee.co.id/koperasitanimakmurgresik',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Petani Sejahtera',
          'Menyediakan produk pertanian segar dan berkualitas.',
          'Tokopedia',
          Colors.amber[50]!,
          Colors.amber[600]!,
          Icons.grain_outlined,
          'https://www.tokopedia.com/koperasipetanisejahtera',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Agro Gresik',
          'Produk pertanian organik dari petani lokal.',
          'TikTok',
          Colors.pink[50]!,
          Colors.pink[600]!,
          Icons.apple_outlined,
          'https://www.tiktok.com/@koperasiagrogresik',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Tani Mandiri',
          'Mendukung petani lokal dengan produk terbaik.',
          'Shopee',
          Colors.red[50]!,
          Colors.red[600]!,
          Icons.local_fire_department_outlined,
          'https://shopee.co.id/koperasitanimandiri',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Sawah Lestari',
          'Produk pertanian berkelanjutan dan ramah lingkungan.',
          'Tokopedia',
          Colors.yellow[50]!,
          Colors.yellow[600]!,
          Icons.local_florist_outlined,
          'https://www.tokopedia.com/koperasisawahlestari',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Tani Bersama',
          'Gotong royong petani untuk kemajuan bersama.',
          'TikTok',
          Colors.deepOrange[50]!,
          Colors.deepOrange[600]!,
          Icons.circle_outlined,
          'https://www.tiktok.com/@koperasitanibersama',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Agro Mandiri',
          'Produk pertanian berkualitas dari petani berpengalaman.',
          'Shopee',
          Colors.purple[50]!,
          Colors.purple[600]!,
          Icons.circle_outlined,
          'https://shopee.co.id/koperasiagromandiri',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Tani Jaya',
          'Menyediakan produk pertanian segar dan sehat.',
          'Tokopedia',
          Colors.teal[50]!,
          Colors.teal[600]!,
          Icons.circle_outlined,
          'https://www.tokopedia.com/koperasitanijaya',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Petani Maju',
          'Mendukung kemajuan petani dengan teknologi modern.',
          'TikTok',
          Colors.brown[50]!,
          Colors.brown[600]!,
          Icons.circle_outlined,
          'https://www.tiktok.com/@koperasipetanimaju',
        ),
        const SizedBox(height: 8),
        _buildMarketplaceCard(
          'Koperasi Agro Sejahtera',
          'Produk pertanian berkualitas untuk kesejahteraan bersama.',
          'Shopee',
          Colors.deepPurple[50]!,
          Colors.deepPurple[600]!,
          Icons.circle_outlined,
          'https://shopee.co.id/koperasiagrosejahtera',
        ),
      ],
    );
  }

  Widget _buildMarketplaceCard(
    String title,
    String description,
    String platform,
    Color backgroundColor,
    Color iconColor,
    IconData icon,
    String url,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Platform Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      
      // Try to launch with external application first
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to browser if external app not available
        await launchUrl(
          uri, 
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      // Show error message to user
      Get.snackbar(
        'Error',
        'Tidak dapat membuka link. Silakan buka browser dan kunjungi: $url',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[600],
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: url));
            Get.snackbar(
              'Info',
              'Link telah disalin ke clipboard',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green[600],
              colorText: Colors.white,
            );
          },
          child: const Text(
            'Copy Link',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
