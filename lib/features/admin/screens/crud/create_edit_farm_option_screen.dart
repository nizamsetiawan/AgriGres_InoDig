import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/farm_option_management_controller.dart';
import 'package:agrigres/features/farm_management/models/farm_option_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditFarmOptionScreen extends StatefulWidget {
  final FarmOptionModel? option;

  const CreateEditFarmOptionScreen({Key? key, this.option}) : super(key: key);

  @override
  State<CreateEditFarmOptionScreen> createState() => _CreateEditFarmOptionScreenState();
}

class _CreateEditFarmOptionScreenState extends State<CreateEditFarmOptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _labelController = TextEditingController();
  final _orderController = TextEditingController();
  final _controller = Get.find<FarmOptionManagementController>();
  bool _isLoading = false;
  bool _isActive = true;
  String _selectedType = 'crop_type';
  int? _colorValue;

  @override
  void initState() {
    super.initState();
    _selectedType = _controller.selectedType.value;
    if (widget.option != null) {
      _valueController.text = widget.option!.value;
      _labelController.text = widget.option!.label;
      _orderController.text = widget.option!.order.toString();
      _isActive = widget.option!.isActive;
      _selectedType = widget.option!.type;
      _colorValue = widget.option!.color;
    } else {
      _orderController.text = '1';
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _labelController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _saveOption() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = int.tryParse(_orderController.text.trim()) ?? 0;

      final option = FarmOptionModel(
        id: widget.option?.id ?? '',
        type: _selectedType,
        value: _valueController.text.trim(),
        label: _labelController.text.trim(),
        order: order,
        isActive: _isActive,
        color: _colorValue,
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
              // Type (only for create)
              if (widget.option == null)
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe',
                    prefixIcon: Icon(Iconsax.category),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'crop_type', child: Text('Jenis Tanaman')),
                    DropdownMenuItem(value: 'status', child: Text('Status')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value ?? 'crop_type';
                    });
                  },
                ),
              if (widget.option == null) const SizedBox(height: TSizes.spaceBtwInputFields),

              // Value
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText: 'Contoh: Padi, preparing',
                  prefixIcon: Icon(Iconsax.tag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Value tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Label
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  hintText: 'Contoh: Padi, Persiapan',
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Label tidak boleh kosong';
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

              // Color (only for status)
              if (_selectedType == 'status')
                TextFormField(
                  initialValue: _colorValue?.toRadixString(16),
                  decoration: const InputDecoration(
                    labelText: 'Color (Hex, Opsional)',
                    hintText: 'FF9E9E9E',
                    prefixIcon: Icon(Iconsax.colorfilter),
                    helperText: 'Color value untuk status (opsional)',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _colorValue = int.tryParse(value, radix: 16);
                    } else {
                      _colorValue = null;
                    }
                  },
                ),
              if (_selectedType == 'status') const SizedBox(height: TSizes.spaceBtwInputFields),

              // Is Active
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Opsi akan ditampilkan jika aktif'),
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

