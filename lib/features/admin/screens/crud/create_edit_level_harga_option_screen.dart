import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/level_harga_option_management_controller.dart';
import 'package:agrigres/features/agri_info/models/level_harga_option_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditLevelHargaOptionScreen extends StatefulWidget {
  final LevelHargaOptionModel? option;

  const CreateEditLevelHargaOptionScreen({Key? key, this.option}) : super(key: key);

  @override
  State<CreateEditLevelHargaOptionScreen> createState() => _CreateEditLevelHargaOptionScreenState();
}

class _CreateEditLevelHargaOptionScreenState extends State<CreateEditLevelHargaOptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _levelIdController = TextEditingController();
  final _orderController = TextEditingController();
  final _controller = Get.find<LevelHargaOptionManagementController>();
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.option != null) {
      _nameController.text = widget.option!.name;
      _levelIdController.text = widget.option!.levelId.toString();
      _orderController.text = widget.option!.order.toString();
      _isActive = widget.option!.isActive;
    } else {
      _orderController.text = '1';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelIdController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _saveOption() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final levelId = int.tryParse(_levelIdController.text.trim()) ?? 0;
      final order = int.tryParse(_orderController.text.trim()) ?? 0;
      final option = LevelHargaOptionModel(
        id: widget.option?.id ?? '',
        levelId: levelId,
        name: _nameController.text.trim(),
        order: order,
        isActive: _isActive,
      );
      if (widget.option == null) {
        await _controller.createOption(option);
      } else {
        await _controller.updateOption(widget.option!.id, option);
      }
      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menyimpan opsi: ${e.toString()}',
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
        title: Text(widget.option == null ? 'Tambah Opsi' : 'Edit Opsi'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Contoh: Produsen',
                  prefixIcon: Icon(Iconsax.tag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              TextFormField(
                controller: _levelIdController,
                decoration: const InputDecoration(
                  labelText: 'Level ID',
                  hintText: '1, 2, 3',
                  prefixIcon: Icon(Iconsax.hashtag),
                  helperText: 'ID yang digunakan untuk API Badan Pangan. Hanya menerima 1, 2, atau 3.',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Level ID tidak boleh kosong';
                  }
                  final levelId = int.tryParse(value);
                  if (levelId == null || levelId < 1) {
                    return 'Level ID harus berupa angka positif';
                  }
                  if (levelId < 1 || levelId > 3) {
                    return 'Level ID harus antara 1-3 (API Badan Pangan hanya menerima 1, 2, atau 3)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
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
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Opsi akan ditampilkan jika aktif'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveOption,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.option == null ? 'Simpan' : 'Perbarui'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

