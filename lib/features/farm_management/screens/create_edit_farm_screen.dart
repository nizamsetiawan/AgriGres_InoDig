import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/farm_management/controllers/farm_management_controller.dart';
import 'package:agrigres/features/farm_management/models/farm_model.dart';
import 'package:agrigres/data/repositories/farm_management/farm_option_repository.dart';
import 'package:agrigres/features/farm_management/models/farm_option_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:intl/intl.dart';

class CreateEditFarmScreen extends StatefulWidget {
  final FarmModel? farm;

  const CreateEditFarmScreen({Key? key, this.farm}) : super(key: key);

  @override
  State<CreateEditFarmScreen> createState() => _CreateEditFarmScreenState();
}

class _CreateEditFarmScreenState extends State<CreateEditFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<FarmManagementController>();
  final _optionRepository = FarmOptionRepository();

  final _farmNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _cropVarietyController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedStatus = 'preparing';
  DateTime? _plantingDate;
  DateTime? _expectedHarvestDate;
  final List<String> _imageUrls = [];

  // Options from Firebase
  final RxList<FarmOptionModel> cropTypes = <FarmOptionModel>[].obs;
  final RxList<FarmOptionModel> statusOptions = <FarmOptionModel>[].obs;
  final RxBool isLoadingOptions = false.obs;

  @override
  void initState() {
    super.initState();
    _loadOptions();
    if (widget.farm != null) {
      _farmNameController.text = widget.farm!.farmName;
      _areaController.text = widget.farm!.area.toString();
      _locationController.text = widget.farm!.location;
      _addressController.text = widget.farm!.address ?? '';
      _cropTypeController.text = widget.farm!.cropType;
      _cropVarietyController.text = widget.farm!.cropVariety ?? '';
      _notesController.text = widget.farm!.notes ?? '';
      _selectedStatus = widget.farm!.status;
      _plantingDate = widget.farm!.plantingDate;
      _expectedHarvestDate = widget.farm!.expectedHarvestDate;
      _imageUrls.addAll(widget.farm!.imageUrls);
    }
  }

  Future<void> _loadOptions() async {
    isLoadingOptions.value = true;
    try {
      final cropTypesList = await _optionRepository.getCropTypes();
      final statusOptionsList = await _optionRepository.getStatusOptions();
      cropTypes.assignAll(cropTypesList);
      statusOptions.assignAll(statusOptionsList);
    } catch (e) {
      // Error already handled in repository
    } finally {
      isLoadingOptions.value = false;
    }
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _areaController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _cropTypeController.dispose();
    _cropVarietyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isPlantingDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isPlantingDate
          ? (_plantingDate ?? DateTime.now())
          : (_expectedHarvestDate ?? DateTime.now().add(const Duration(days: 90))),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isPlantingDate) {
          _plantingDate = picked;
        } else {
          _expectedHarvestDate = picked;
        }
      });
    }
  }

  Future<void> _saveFarm() async {
    if (!_formKey.currentState!.validate()) return;

    final farm = FarmModel(
      id: widget.farm?.id ?? '',
      userId: widget.farm?.userId ?? '',
      farmName: _farmNameController.text.trim(),
      area: double.tryParse(_areaController.text.trim()) ?? 0.0,
      location: _locationController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      cropType: _cropTypeController.text.trim(),
      cropVariety: _cropVarietyController.text.trim().isEmpty
          ? null
          : _cropVarietyController.text.trim().isNotEmpty
              ? _cropVarietyController.text.trim()
              : null,
      plantingDate: _plantingDate,
      expectedHarvestDate: _expectedHarvestDate,
      status: _selectedStatus,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      imageUrls: _imageUrls,
      createdAt: widget.farm?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.farm == null) {
      await _controller.createFarm(farm);
    } else {
      await _controller.updateFarm(farm);
    }

    if (mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.farm != null;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(isEdit ? 'Edit Lahan' : 'Tambah Lahan'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Farm Name
              TextFormField(
                controller: _farmNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lahan',
                  prefixIcon: Icon(Iconsax.home_2),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lahan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Area
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Luas Lahan (hektar)',
                  prefixIcon: Icon(Iconsax.ruler),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Luas lahan tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Luas harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: Icon(Iconsax.location),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap (Opsional)',
                  prefixIcon: Icon(Iconsax.map),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Crop Type
              Obx(
                () => isLoadingOptions.value
                    ? DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Jenis Tanaman',
                          prefixIcon: Icon(Iconsax.tree),
                        ),
                        items: const [],
                        onChanged: null,
                      )
                    : DropdownButtonFormField<String>(
                        value: _cropTypeController.text.isEmpty ? null : _cropTypeController.text,
                        decoration: const InputDecoration(
                          labelText: 'Jenis Tanaman',
                          prefixIcon: Icon(Iconsax.tree),
                        ),
                        items: cropTypes.map((option) {
                          return DropdownMenuItem(
                            value: option.value,
                            child: Text(option.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _cropTypeController.text = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jenis tanaman harus dipilih';
                          }
                          return null;
                        },
                      ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Crop Variety
              TextFormField(
                controller: _cropVarietyController,
                decoration: const InputDecoration(
                  labelText: 'Varietas (Opsional)',
                  prefixIcon: Icon(Iconsax.tick_circle),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Status
              Obx(
                () => isLoadingOptions.value
                    ? DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Iconsax.info_circle),
                        ),
                        items: const [],
                        onChanged: null,
                      )
                    : DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Iconsax.info_circle),
                        ),
                        items: statusOptions.map((option) {
                          return DropdownMenuItem(
                            value: option.value,
                            child: Text(option.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value ?? (statusOptions.isNotEmpty ? statusOptions.first.value : 'preparing');
                          });
                        },
                      ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Planting Date
              InkWell(
                onTap: () => _selectDate(context, true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.calendar_1),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Tanam (Opsional)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _plantingDate != null
                                  ? dateFormat.format(_plantingDate!)
                                  : 'Pilih tanggal',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (_plantingDate != null)
                        IconButton(
                          icon: const Icon(Iconsax.close_circle, size: 20),
                          onPressed: () {
                            setState(() {
                              _plantingDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Expected Harvest Date
              InkWell(
                onTap: () => _selectDate(context, false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.timer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimasi Tanggal Panen (Opsional)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _expectedHarvestDate != null
                                  ? dateFormat.format(_expectedHarvestDate!)
                                  : 'Pilih tanggal',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (_expectedHarvestDate != null)
                        IconButton(
                          icon: const Icon(Iconsax.close_circle, size: 20),
                          onPressed: () {
                            setState(() {
                              _expectedHarvestDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: _controller.isSaving.value ? null : _saveFarm,
                    child: _controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Lahan'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

