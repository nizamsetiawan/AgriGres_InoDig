import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/categories_management_controller.dart';
import 'package:agrigres/features/detection/models/category_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditCategoryScreen extends StatefulWidget {
  final CategoryModel? category; // null for create, not null for edit

  const CreateEditCategoryScreen({Key? key, this.category}) : super(key: key);

  @override
  State<CreateEditCategoryScreen> createState() => _CreateEditCategoryScreenState();
}

class _CreateEditCategoryScreenState extends State<CreateEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _parentIdController = TextEditingController();
  final _controller = Get.find<CategoriesManagementController>();
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _imageUrlController.text = widget.category!.image;
      _parentIdController.text = widget.category!.parentId;
      _isFeatured = widget.category!.isFeatured;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _parentIdController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.category == null) {
        // Create new category
        final category = CategoryModel(
          id: '',
          name: _nameController.text.trim(),
          image: _imageUrlController.text.trim(),
          parentId: _parentIdController.text.trim(),
          isFeatured: _isFeatured,
        );
        await _controller.createCategory(category);
        TLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Kategori berhasil dibuat',
        );
      } else {
        // Update existing category
        final updatedCategory = CategoryModel(
          id: widget.category!.id,
          name: _nameController.text.trim(),
          image: _imageUrlController.text.trim(),
          parentId: _parentIdController.text.trim(),
          isFeatured: _isFeatured,
        );
        await _controller.updateCategory(widget.category!.id, updatedCategory);
        TLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Kategori berhasil diperbarui',
        );
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(widget.category == null ? 'Tambah Kategori' : 'Edit Kategori'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar',
                  prefixIcon: Icon(Iconsax.image),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Parent ID
              TextFormField(
                controller: _parentIdController,
                decoration: const InputDecoration(
                  labelText: 'Parent ID (Opsional)',
                  prefixIcon: Icon(Iconsax.hierarchy),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Is Featured
              CheckboxListTile(
                title: const Text('Featured'),
                value: _isFeatured,
                onChanged: (value) {
                  setState(() {
                    _isFeatured = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
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
                      : Text(widget.category == null ? 'Simpan Kategori' : 'Perbarui Kategori'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

