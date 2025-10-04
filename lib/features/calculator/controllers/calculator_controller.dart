import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController {
  // Form controllers
  final jenisTanamanController = TextEditingController();
  final luasLahanController = TextEditingController();
  final biayaPengolahanController = TextEditingController();
  final biayaBibitController = TextEditingController();
  final biayaPupukController = TextEditingController();
  final biayaTenagaKerjaController = TextEditingController();
  final hasilPanenController = TextEditingController();
  final hargaJualController = TextEditingController();
  final siklusTanamController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Calculation results
  final RxDouble totalBiayaProduksi = 0.0.obs;
  final RxDouble totalHasilPanen = 0.0.obs;
  final RxDouble totalPendapatan = 0.0.obs;
  final RxDouble labaBersih = 0.0.obs;
  final RxString status = ''.obs;

  @override
  void onClose() {
    // Dispose controllers
    jenisTanamanController.dispose();
    luasLahanController.dispose();
    biayaPengolahanController.dispose();
    biayaBibitController.dispose();
    biayaPupukController.dispose();
    biayaTenagaKerjaController.dispose();
    hasilPanenController.dispose();
    hargaJualController.dispose();
    siklusTanamController.dispose();
    super.onClose();
  }

  // Calculate agricultural business
  void calculateResults() {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get input values
      final luasLahan = double.tryParse(luasLahanController.text) ?? 0.0;
      final biayaPengolahan = double.tryParse(biayaPengolahanController.text) ?? 0.0;
      final biayaBibit = double.tryParse(biayaBibitController.text) ?? 0.0;
      final biayaPupuk = double.tryParse(biayaPupukController.text) ?? 0.0;
      final biayaTenagaKerja = double.tryParse(biayaTenagaKerjaController.text) ?? 0.0;
      final hasilPanen = double.tryParse(hasilPanenController.text) ?? 0.0;
      final hargaJual = double.tryParse(hargaJualController.text) ?? 0.0;

      // Validate inputs
      if (luasLahan <= 0 || biayaPengolahan <= 0 || biayaBibit <= 0 || 
          biayaPupuk <= 0 || biayaTenagaKerja <= 0 || hasilPanen <= 0 || hargaJual <= 0) {
        errorMessage.value = 'Semua field harus diisi dengan nilai yang valid';
        return;
      }

      // Calculate total production cost per hectare
      final biayaProduksiPerHa = biayaPengolahan + biayaBibit + biayaPupuk + biayaTenagaKerja;
      
      // Calculate total production cost for all land
      totalBiayaProduksi.value = biayaProduksiPerHa * luasLahan;
      
      // Calculate total harvest yield for all land
      totalHasilPanen.value = hasilPanen * luasLahan;
      
      // Calculate total revenue
      totalPendapatan.value = totalHasilPanen.value * hargaJual;
      
      // Calculate net profit
      labaBersih.value = totalPendapatan.value - totalBiayaProduksi.value;
      
      // Determine status
      if (labaBersih.value > 0) {
        status.value = 'Untung';
      } else if (labaBersih.value < 0) {
        status.value = 'Rugi';
      } else {
        status.value = 'BEP (Break Even Point)';
      }

      // Navigate to results screen
      Get.toNamed('/calculator-results');

    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan dalam perhitungan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Reset form
  void resetForm() {
    jenisTanamanController.clear();
    luasLahanController.clear();
    biayaPengolahanController.clear();
    biayaBibitController.clear();
    biayaPupukController.clear();
    biayaTenagaKerjaController.clear();
    hasilPanenController.clear();
    hargaJualController.clear();
    siklusTanamController.clear();
    
    totalBiayaProduksi.value = 0.0;
    totalHasilPanen.value = 0.0;
    totalPendapatan.value = 0.0;
    labaBersih.value = 0.0;
    status.value = '';
    errorMessage.value = '';
  }
}
