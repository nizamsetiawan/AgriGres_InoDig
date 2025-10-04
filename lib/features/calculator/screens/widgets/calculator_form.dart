import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/features/calculator/controllers/calculator_controller.dart';

class TCalculatorForm extends StatelessWidget {
  const TCalculatorForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.put(CalculatorController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calculate_outlined,
              color: TColors.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Kalkulator Usaha Pertanian',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _showInfoDialog(context),
              icon: Icon(
                Icons.info_outline,
                color: Colors.grey[600],
                size: 20,
              ),
              tooltip: 'Info Perhitungan',
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Masukkan Data Aktual Sesuai dengan Lahan Anda.',
          style: textTheme.bodyMedium,
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // Form Fields
        TextFormField(
          controller: controller.jenisTanamanController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.category),
            labelText: 'Jenis Tanaman',
            hintText: 'Contoh: Padi, Jagung, Cabai',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.luasLahanController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.map),
            labelText: 'Luas Lahan (hektar)',
            hintText: 'Contoh: 2',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.biayaPengolahanController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.money),
            labelText: 'Biaya Pengolahan Lahan per ha (Rp)',
            hintText: 'Contoh: 1.500.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.biayaBibitController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.safe_home),
            labelText: 'Biaya Bibit per ha (Rp)',
            hintText: 'Contoh: 800.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.biayaPupukController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.health),
            labelText: 'Biaya Pupuk dan Obat per ha (Rp)',
            hintText: 'Contoh: 1.200.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.biayaTenagaKerjaController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.people),
            labelText: 'Biaya Tenaga Kerja per ha (Rp)',
            hintText: 'Contoh: 2.000.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.hasilPanenController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.weight),
            labelText: 'Hasil Panen per ha (kg)',
            hintText: 'Contoh: 6.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.hargaJualController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.money_recive),
            labelText: 'Harga Jual per kg (Rp)',
            hintText: 'Contoh: 5.000',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwInputFields),

        TextFormField(
          controller: controller.siklusTanamController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Iconsax.calendar),
            labelText: 'Siklus Tanam (hari)',
            hintText: 'Contoh: 100',
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        // Error Message
        Obx(() {
          if (controller.errorMessage.value.isNotEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        // Calculate Button
        Obx(() => SizedBox(
          width: double.infinity,
          child: controller.isLoading.value
              ? _buildShimmerButton()
              : ElevatedButton(
                  onPressed: () => controller.calculateResults(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Hitung',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        )),
      ],
    );
  }

  Widget _buildShimmerButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Menghitung...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calculate_outlined, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kalkulator Usaha Pertanian',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Menghitung Untung Usaha Pertanian dengan Cepat',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      _buildInfoCard(
                        Icons.lightbulb_outline,
                        'Panduan Petani Cerdas',
                        'Usaha pertanian seperti cabai, padi, atau sayur-mayur membutuhkan modal yang tidak sedikit. Namun, dengan perhitungan matang, Anda bisa memperoleh hasil yang menguntungkan dan berkelanjutan.',
                        Colors.amber[50]!,
                        Colors.amber[600]!,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Components
                      _buildInfoCard(
                        Icons.construction_outlined,
                        'Komponen Biaya Pertanian',
                        '• Lahan: Sewa atau milik sendiri tetap perlu dihitung nilainya\n• Benih/Bibit: Disesuaikan dengan luas lahan dan jenis tanaman\n• Pupuk & Pestisida: Menentukan kesuburan dan perlindungan tanaman\n• Tenaga Kerja: Penanaman, pemeliharaan, hingga panen\n• Distribusi: Termasuk biaya angkut dan kemasan hasil panen',
                        Colors.blue[50]!,
                        Colors.blue[600]!,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Example
                      _buildInfoCard(
                        Icons.emoji_objects_outlined,
                        'Simulasi Usaha Cabai 1.000 m²',
                        '• Total biaya: Rp 3.800.000\n• Hasil panen: 300 kg @ Rp 25.000/kg = Rp 7.500.000\n• Laba Bersih: Rp 3.700.000',
                        Colors.green[50]!,
                        Colors.green[600]!,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Calculation Methods
                      _buildCalculationSection(),
                      
                      const SizedBox(height: 16),
                      
                      // Tips
                      _buildInfoCard(
                        Icons.tips_and_updates_outlined,
                        'Tips Agar Pertanian Lebih Menguntungkan',
                        '• Gunakan varietas unggul dan tahan penyakit\n• Waktu tanam yang tepat untuk menghindari panen massal\n• Pasarkan langsung ke konsumen atau pengepul terpercaya\n• Gunakan kalkulator untuk merancang strategi pertanian',
                        Colors.purple[50]!,
                        Colors.purple[600]!,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TColors.primary,
                          side: BorderSide(color: TColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Mulai Hitung'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String description, Color backgroundColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
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

  Widget _buildCalculationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_outlined, color: TColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Cara Perhitungan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: TColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCalculationItem(
            Icons.money_outlined,
            'Total Biaya Produksi',
            '= (Biaya Pengolahan + Bibit + Pupuk + Tenaga Kerja) × Luas Lahan',
          ),
          const SizedBox(height: 8),
          _buildCalculationItem(
            Icons.scale_outlined,
            'Total Hasil Panen',
            '= Hasil Panen per ha × Luas Lahan',
          ),
          const SizedBox(height: 8),
          _buildCalculationItem(
            Icons.trending_up_outlined,
            'Total Pendapatan',
            '= Total Hasil Panen × Harga Jual per kg',
          ),
          const SizedBox(height: 8),
          _buildCalculationItem(
            Icons.account_balance_wallet_outlined,
            'Laba Bersih',
            '= Total Pendapatan - Total Biaya Produksi',
          ),
          const SizedBox(height: 8),
          _buildCalculationItem(
            Icons.assessment_outlined,
            'Status',
            'Untung: Laba > 0 | Rugi: Laba < 0 | BEP: Laba = 0',
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationItem(IconData icon, String title, String formula) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 14,
            color: TColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formula,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

} 