import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/analyze_management_controller.dart';
import 'package:agrigres/features/detection/models/result_analyze_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditAnalyzeScreen extends StatefulWidget {
  final ResultAnalyzeModel? analyze; // null for create, not null for edit

  const CreateEditAnalyzeScreen({Key? key, this.analyze}) : super(key: key);

  @override
  State<CreateEditAnalyzeScreen> createState() => _CreateEditAnalyzeScreenState();
}

class _CreateEditAnalyzeScreenState extends State<CreateEditAnalyzeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _selectedLabel = ''.obs;
  final _selectedCategory = ''.obs;
  final _gejalaController = TextEditingController();
  final _penyebabController = TextEditingController();
  final _pencegahanController = TextEditingController();
  final _pengendalianHayatiController = TextEditingController();
  final _pengendalianKimiawiController = TextEditingController();
  final _imagePathController = TextEditingController();
  final _probabilityController = TextEditingController();
  final _controller = Get.find<AnalyzeManagementController>();
  bool _isLoading = false;
  String? _docId;

  @override
  void initState() {
    super.initState();
    // Load labels and categories if not loaded
    if (_controller.availableLabels.isEmpty) {
      _controller.loadAvailableLabels();
    }
    if (_controller.availableCategories.isEmpty) {
      _controller.loadAvailableCategories();
    }
    
    if (widget.analyze != null) {
      _selectedLabel.value = widget.analyze!.label;
      _selectedCategory.value = widget.analyze!.kategori;
      _gejalaController.text = widget.analyze!.gejala;
      _penyebabController.text = widget.analyze!.penyebab;
      _pencegahanController.text = widget.analyze!.pencegahan;
      _pengendalianHayatiController.text = widget.analyze!.pengendalianHayati;
      _pengendalianKimiawiController.text = widget.analyze!.pengendalianKimiawi;
      _imagePathController.text = widget.analyze!.imagePath;
      _probabilityController.text = widget.analyze!.probability;
      
      // Get document ID from cache or fetch
      _docId = _controller.analyzeDocIds[widget.analyze!.label];
      if (_docId == null) {
        _getDocumentId();
      }
    }
  }

  Future<void> _getDocumentId() async {
    if (widget.analyze != null) {
      _docId = await _controller.getAnalyzeByLabel(widget.analyze!.label);
    }
  }

  @override
  void dispose() {
    _gejalaController.dispose();
    _penyebabController.dispose();
    _pencegahanController.dispose();
    _pengendalianHayatiController.dispose();
    _pengendalianKimiawiController.dispose();
    _imagePathController.dispose();
    _probabilityController.dispose();
    super.dispose();
  }

  Future<void> _saveAnalyze() async {
    // Validate dropdown selections first
    if (_selectedLabel.value.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Silakan pilih label penyakit',
      );
      return;
    }
    
    if (_selectedCategory.value.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Silakan pilih kategori',
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final analyze = ResultAnalyzeModel(
        label: _selectedLabel.value,
        kategori: _selectedCategory.value,
        gejala: _gejalaController.text.trim(),
        penyebab: _penyebabController.text.trim(),
        pencegahan: _pencegahanController.text.trim(),
        pengendalianHayati: _pengendalianHayatiController.text.trim(),
        pengendalianKimiawi: _pengendalianKimiawiController.text.trim(),
        imagePath: _imagePathController.text.trim(),
        probability: _probabilityController.text.trim(),
      );

      if (widget.analyze == null) {
        // Create new
        await _controller.createAnalyze(analyze);
      } else {
        // Update existing
        if (_docId != null) {
          await _controller.updateAnalyze(_docId!, analyze);
        } else {
          TLoaders.errorSnackBar(
            title: 'Kesalahan',
            message: 'ID dokumen tidak ditemukan',
          );
        }
      }
      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: e.toString(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(widget.analyze == null ? 'Tambah Data Analisis' : 'Edit Data Analisis'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label (Nama Penyakit) - Required - Dropdown
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Label (Nama Penyakit) *',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                        Text(
                          'Pilih label dari daftar penyakit yang sudah dikonfigurasi di DetectionConfig',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.refresh),
                    onPressed: () => _controller.loadAvailableLabels(),
                    tooltip: 'Refresh Labels',
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              Obx(
                () {
                  if (_controller.availableLabels.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.info_circle, color: Colors.amber[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tidak ada label tersedia. Pastikan sudah menambahkan tanaman di Konfigurasi Deteksi.',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedLabel.value.isEmpty ? null : _selectedLabel.value,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                        prefixIcon: Icon(Iconsax.tag),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: _controller.availableLabels.map((String label) {
                        return DropdownMenuItem<String>(
                          value: label,
                          child: Text(label),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _selectedLabel.value = newValue;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Label tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Kategori - Required - Dropdown
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori *',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                        Text(
                          'Pilih kategori dari daftar kategori yang ada di Firebase',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.refresh),
                    onPressed: () => _controller.loadAvailableCategories(),
                    tooltip: 'Refresh Categories',
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              Obx(
                () {
                  if (_controller.availableCategories.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Iconsax.info_circle, color: Colors.amber[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tidak ada kategori tersedia. Pastikan sudah menambahkan kategori di Manajemen Kategori.',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory.value.isEmpty ? null : _selectedCategory.value,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon: Icon(Iconsax.category),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: _controller.availableCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _selectedCategory.value = newValue;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Gejala
              TextFormField(
                controller: _gejalaController,
                decoration: const InputDecoration(
                  labelText: 'Gejala',
                  hintText: 'Deskripsi gejala penyakit...',
                  prefixIcon: Icon(Iconsax.info_circle),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                minLines: 3,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Penyebab
              TextFormField(
                controller: _penyebabController,
                decoration: const InputDecoration(
                  labelText: 'Penyebab',
                  hintText: 'Penyebab penyakit...',
                  prefixIcon: Icon(Iconsax.warning_2),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                minLines: 3,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Pencegahan
              TextFormField(
                controller: _pencegahanController,
                decoration: const InputDecoration(
                  labelText: 'Pencegahan',
                  hintText: 'Cara pencegahan penyakit (pisahkan dengan titik)...',
                  prefixIcon: Icon(Iconsax.shield_tick),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                minLines: 4,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Pengendalian Hayati
              TextFormField(
                controller: _pengendalianHayatiController,
                decoration: const InputDecoration(
                  labelText: 'Pengendalian Hayati',
                  hintText: 'Cara pengendalian secara hayati...',
                  prefixIcon: Icon(Iconsax.scan_barcode),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                minLines: 3,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Pengendalian Kimiawi
              TextFormField(
                controller: _pengendalianKimiawiController,
                decoration: const InputDecoration(
                  labelText: 'Pengendalian Kimiawi',
                  hintText: 'Cara pengendalian secara kimiawi...',
                  prefixIcon: Icon(Iconsax.danger),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                minLines: 3,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Image Path
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(
                  labelText: 'Image Path (Opsional)',
                  hintText: 'URL atau path gambar',
                  prefixIcon: Icon(Iconsax.image),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Probability
              TextFormField(
                controller: _probabilityController,
                decoration: const InputDecoration(
                  labelText: 'Probability (Opsional)',
                  hintText: '85.5%',
                  prefixIcon: Icon(Iconsax.chart),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAnalyze,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.analyze == null ? 'Simpan Data Analisis' : 'Perbarui Data Analisis'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

