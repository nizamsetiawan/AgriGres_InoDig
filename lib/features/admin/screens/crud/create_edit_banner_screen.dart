import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/banners_management_controller.dart';
import 'package:agrigres/features/detection/models/banner_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditBannerScreen extends StatefulWidget {
  final BannerModel? banner; // null for create, not null for edit

  const CreateEditBannerScreen({Key? key, this.banner}) : super(key: key);

  @override
  State<CreateEditBannerScreen> createState() => _CreateEditBannerScreenState();
}

class _CreateEditBannerScreenState extends State<CreateEditBannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _targetScreenController = TextEditingController();
  final _controller = Get.find<BannersManagementController>();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _imageUrlController.text = widget.banner!.imageUrl;
      _targetScreenController.text = widget.banner!.targetScreen;
      _isActive = widget.banner!.active;
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _targetScreenController.dispose();
    super.dispose();
  }

  Future<void> _saveBanner() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.banner == null) {
        // Create new banner
        final banner = BannerModel(
          id: '',
          imageUrl: _imageUrlController.text.trim(),
          targetScreen: _targetScreenController.text.trim(),
          active: _isActive,
        );
        await _controller.createBanner(banner);
        TLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Banner berhasil dibuat',
        );
      } else {
        // Update existing banner
        final updatedBanner = BannerModel(
          id: widget.banner!.id,
          imageUrl: _imageUrlController.text.trim(),
          targetScreen: _targetScreenController.text.trim(),
          active: _isActive,
        );
        await _controller.updateBanner(widget.banner!.id, updatedBanner);
        TLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Banner berhasil diperbarui',
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
        title: Text(widget.banner == null ? 'Tambah Banner' : 'Edit Banner'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar',
                  prefixIcon: Icon(Iconsax.image),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL gambar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Target Screen
              TextFormField(
                controller: _targetScreenController,
                decoration: const InputDecoration(
                  labelText: 'Target Screen',
                  prefixIcon: Icon(Iconsax.monitor),
                  hintText: 'Contoh: /home, /article, dll',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Target screen tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Is Active
              CheckboxListTile(
                title: const Text('Aktif'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveBanner,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.banner == null ? 'Simpan Banner' : 'Perbarui Banner'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

