import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/guidelines_management_controller.dart';
import 'package:agrigres/features/detection/models/guideline_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditGuidelineScreen extends StatefulWidget {
  final GuidelineModel? guideline; // null for create, not null for edit

  const CreateEditGuidelineScreen({Key? key, this.guideline}) : super(key: key);

  @override
  State<CreateEditGuidelineScreen> createState() => _CreateEditGuidelineScreenState();
}

class _CreateEditGuidelineScreenState extends State<CreateEditGuidelineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _iconController = TextEditingController();
  final _orderController = TextEditingController();
  final _controller = Get.find<GuidelinesManagementController>();
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.guideline != null) {
      _titleController.text = widget.guideline!.title;
      _descriptionController.text = widget.guideline!.description;
      _iconController.text = widget.guideline!.icon ?? '';
      _orderController.text = widget.guideline!.order.toString();
      _isActive = widget.guideline!.isActive;
    } else {
      _orderController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _saveGuideline() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = int.tryParse(_orderController.text.trim()) ?? 0;

      final guideline = GuidelineModel(
        id: widget.guideline?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        icon: _iconController.text.trim().isEmpty ? null : _iconController.text.trim(),
        order: order,
        isActive: _isActive,
      );

      if (widget.guideline == null) {
        // Create new
        await _controller.createGuideline(guideline);
      } else {
        // Update existing
        await _controller.updateGuideline(widget.guideline!.id, guideline);
      }
      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menyimpan panduan: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(widget.guideline == null ? 'Tambah Panduan' : 'Edit Panduan'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  hintText: 'Contoh: Langkah 1: Ambil Gambar Daun',
                  prefixIcon: Icon(Iconsax.tag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi panduan...',
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Icon (optional)
              TextFormField(
                controller: _iconController,
                decoration: const InputDecoration(
                  labelText: 'Icon (Opsional)',
                  hintText: 'Contoh: 1, 2, ℹ️, 📚',
                  prefixIcon: Icon(Iconsax.image),
                  helperText: 'Bisa berupa angka, emoji, atau karakter',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Order
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(
                  labelText: 'Urutan',
                  hintText: '1, 2, 3, ...',
                  prefixIcon: Icon(Iconsax.sort),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Urutan tidak boleh kosong';
                  }
                  final order = int.tryParse(value);
                  if (order == null || order < 0) {
                    return 'Urutan harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Is Active
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Panduan akan ditampilkan jika aktif'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveGuideline,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.guideline == null ? 'Simpan' : 'Perbarui'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

