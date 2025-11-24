import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/detection_config_management_controller.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditDetectionConfigScreen extends StatefulWidget {
  final DetectionConfigModel? config; // null for create, not null for edit

  const CreateEditDetectionConfigScreen({Key? key, this.config}) : super(key: key);

  @override
  State<CreateEditDetectionConfigScreen> createState() => _CreateEditDetectionConfigScreenState();
}

class _CreateEditDetectionConfigScreenState extends State<CreateEditDetectionConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelsController = TextEditingController();
  final _keywordController = TextEditingController();
  final _controller = Get.find<DetectionConfigManagementController>();
  bool _useCustomKeyword = false;
  bool _isLoading = false;

  final _plantTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.config != null) {
      _plantTypeController.text = widget.config!.plantType;
      _labelsController.text = widget.config!.labels.join('\n');
      _keywordController.text = widget.config!.customKeyword ?? '';
      _useCustomKeyword = widget.config!.customKeyword != null && widget.config!.customKeyword!.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _plantTypeController.dispose();
    _labelsController.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Parse labels from text
      final labelsText = _labelsController.text.trim();
      final labels = labelsText
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (labels.isEmpty) {
        TLoaders.errorSnackBar(
          title: 'Kesalahan',
          message: 'Minimal harus ada 1 label penyakit',
        );
        setState(() => _isLoading = false);
        return;
      }

      final plantType = widget.config?.plantType ?? _plantTypeController.text.trim();
      
      if (plantType.isEmpty) {
        TLoaders.errorSnackBar(
          title: 'Kesalahan',
          message: 'Nama tanaman tidak boleh kosong',
        );
        setState(() => _isLoading = false);
        return;
      }

      final config = DetectionConfigModel(
        plantType: plantType,
        labels: labels,
        customKeyword: _useCustomKeyword && _keywordController.text.trim().isNotEmpty
            ? _keywordController.text.trim()
            : null,
      );

      if (widget.config == null) {
        // Create new
        await _controller.createConfig(config);
      } else {
        // Update existing
        await _controller.updateConfig(config);
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
        title: Text(widget.config == null ? 'Tambah Tanaman Baru' : 'Edit Konfigurasi: ${widget.config!.plantType}'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plant Type Info
              if (widget.config != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Edit konfigurasi untuk ${widget.config!.plantType}. Setiap label penyakit harus dipisahkan dengan baris baru.',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.config != null) const SizedBox(height: TSizes.spaceBtwSections),

              // Plant Type Name (only for create)
              if (widget.config == null) ...[
                Text(
                  'Nama Tanaman',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                Text(
                  'Masukkan nama tanaman (contoh: Tanaman Cabai, Tanaman Padi, dll)',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: _plantTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Tanaman',
                    hintText: 'Tanaman Cabai',
                    prefixIcon: Icon(Iconsax.scan_barcode),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tanaman tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],

              // Labels Section
              Text(
                'Daftar Label Penyakit',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),
              Text(
                'Masukkan setiap label penyakit dalam baris terpisah. Format: "Nama Penyakit (Nama Indonesia)"',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: _labelsController,
                decoration: const InputDecoration(
                  labelText: 'Labels (satu per baris)',
                  hintText: 'Late Blight (Busuk Daun)\nTomat Sehat\n...',
                  prefixIcon: Icon(Iconsax.tag),
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                minLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Labels tidak boleh kosong';
                  }
                  final labels = value
                      .split('\n')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  if (labels.isEmpty) {
                    return 'Minimal harus ada 1 label';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Custom Keyword Section
              Row(
                children: [
                  Checkbox(
                    value: _useCustomKeyword,
                    onChanged: (value) {
                      setState(() {
                        _useCustomKeyword = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gunakan Custom Keyword',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Jika diaktifkan, akan menggunakan keyword ini langsung tanpa generate dari labels',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              if (_useCustomKeyword) ...[
                TextFormField(
                  controller: _keywordController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Keyword/Prompt',
                    hintText: 'Masukkan prompt lengkap untuk Gemini API...',
                    prefixIcon: Icon(Iconsax.document_text),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 15,
                  minLines: 10,
                  validator: (value) {
                    if (_useCustomKeyword && (value == null || value.trim().isEmpty)) {
                      return 'Custom keyword tidak boleh kosong jika diaktifkan';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],

              // Info about cache
              Container(
                padding: const EdgeInsets.all(12),
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
                        'Perubahan akan diterapkan setelah cache expire (1 jam) atau clear cache di aplikasi.',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveConfig,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan Konfigurasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

