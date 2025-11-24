import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/agri_edu_category_management_controller.dart';
import 'package:agrigres/features/agri_edu/models/agri_edu_category_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditAgriEduCategoryScreen extends StatefulWidget {
  final AgriEduCategoryModel? category; // null for create, not null for edit

  const CreateEditAgriEduCategoryScreen({Key? key, this.category}) : super(key: key);

  @override
  State<CreateEditAgriEduCategoryScreen> createState() => _CreateEditAgriEduCategoryScreenState();
}

class _CreateEditAgriEduCategoryScreenState extends State<CreateEditAgriEduCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _orderController = TextEditingController();
  final _controller = Get.find<AgriEduCategoryManagementController>();
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _orderController.text = widget.category!.order.toString();
      _isActive = widget.category!.isActive;
    } else {
      _orderController.text = '1';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = int.tryParse(_orderController.text.trim()) ?? 0;

      final category = AgriEduCategoryModel(
        id: widget.category?.id ?? '',
        name: _nameController.text.trim(),
        order: order,
        isActive: _isActive,
      );

      if (widget.category == null) {
        // Create new
        await _controller.createCategory(category);
      } else {
        // Update existing
        await _controller.updateCategory(widget.category!.id, category);
      }
      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menyimpan kategori: ${e.toString()}',
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
        title: Text(widget.category == null ? 'Tambah Kategori' : 'Edit Kategori'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  hintText: 'Contoh: Pertanian',
                  prefixIcon: Icon(Iconsax.category),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kategori tidak boleh kosong';
                  }
                  return null;
                },
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
                subtitle: const Text('Kategori akan ditampilkan jika aktif'),
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
                  onPressed: _isLoading ? null : _saveCategory,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.category == null ? 'Simpan' : 'Perbarui'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

