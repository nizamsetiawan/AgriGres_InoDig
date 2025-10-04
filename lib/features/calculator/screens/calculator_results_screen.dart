import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/calculator/controllers/calculator_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:intl/intl.dart';

class CalculatorResultsScreen extends StatelessWidget {
  const CalculatorResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        showBackArrow: true,
        title: const Text('Hasil Analisis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderSection(),
            
            const SizedBox(height: 24),
            
            // Results Section
            _buildResultsSection(controller, currencyFormat),
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
          'Hasil Analisis Usaha Pertanian',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Berikut adalah hasil perhitungan analisis usaha pertanian Anda.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection(CalculatorController controller, NumberFormat currencyFormat) {
    return Column(
      children: [
        _buildResultField(
          Icons.eco_outlined,
          'Jenis Tanaman',
          controller.jenisTanamanController.text.isNotEmpty 
              ? controller.jenisTanamanController.text 
              : 'Contoh: Padi, Jagung, Cabai',
          Colors.green[600]!,
        ),
        const SizedBox(height: 12),
        _buildResultField(
          Icons.money_outlined,
          'Total Biaya Produksi',
          currencyFormat.format(controller.totalBiayaProduksi.value),
          Colors.red[600]!,
        ),
        const SizedBox(height: 12),
        _buildResultField(
          Icons.scale_outlined,
          'Total Hasil Panen',
          '${controller.totalHasilPanen.value.toStringAsFixed(0)} kg',
          Colors.blue[600]!,
        ),
        const SizedBox(height: 12),
        _buildResultField(
          Icons.trending_up_outlined,
          'Total Pendapatan',
          currencyFormat.format(controller.totalPendapatan.value),
          Colors.green[600]!,
        ),
        const SizedBox(height: 12),
        _buildResultField(
          Icons.account_balance_wallet_outlined,
          'Laba Bersih',
          currencyFormat.format(controller.labaBersih.value),
          controller.labaBersih.value >= 0 ? Colors.green[600]! : Colors.red[600]!,
        ),
        const SizedBox(height: 12),
        _buildResultField(
          Icons.schedule_outlined,
          'Siklus Tanam',
          controller.siklusTanamController.text.isNotEmpty 
              ? '${controller.siklusTanamController.text} hari'
              : 'Isi lama waktu satu periode tanam.',
          Colors.orange[600]!,
        ),
        const SizedBox(height: 12),
        _buildStatusField(controller),
        const SizedBox(height: 24),
        
        // Action Button
        _buildActionButton(controller),
      ],
    );
  }

  Widget _buildResultField(IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
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
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusField(CalculatorController controller) {
    Color statusColor;
    IconData statusIcon;
    
    if (controller.labaBersih.value > 0) {
      statusColor = Colors.green[600]!;
      statusIcon = Icons.trending_up;
    } else if (controller.labaBersih.value < 0) {
      statusColor = Colors.red[600]!;
      statusIcon = Icons.trending_down;
    } else {
      statusColor = Colors.orange[600]!;
      statusIcon = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              statusIcon,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.status.value.isNotEmpty 
                      ? controller.status.value 
                      : 'Untung / Rugi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(CalculatorController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          controller.resetForm();
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Hitung Lagi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
