import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/planting_calendar_management_controller.dart';
import 'package:agrigres/features/planting_calendar/models/planting_calendar_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

class CreateEditPlantingCalendarScreen extends StatefulWidget {
  final PlantingCalendarModel? calendar;

  const CreateEditPlantingCalendarScreen({Key? key, this.calendar}) : super(key: key);

  @override
  State<CreateEditPlantingCalendarScreen> createState() => _CreateEditPlantingCalendarScreenState();
}

class _CreateEditPlantingCalendarScreenState extends State<CreateEditPlantingCalendarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<PlantingCalendarManagementController>();
  
  final _cropNameController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _plantingMonthController = TextEditingController();
  final _harvestMonthController = TextEditingController();
  final _plantingDurationController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  final List<TextEditingController> _varietyControllers = [];
  final List<TextEditingController> _careTipControllers = [];
  
  bool _isActive = true;

  final List<String> months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  final List<String> cropTypes = [
    'Padi',
    'Jagung',
    'Sayuran',
    'Buah-buahan',
    'Palawija',
    'Hortikultura',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.calendar != null) {
      _cropNameController.text = widget.calendar!.cropName;
      _cropTypeController.text = widget.calendar!.cropType;
      _plantingMonthController.text = widget.calendar!.plantingMonth;
      _harvestMonthController.text = widget.calendar!.harvestMonth;
      _plantingDurationController.text = widget.calendar!.plantingDuration.toString();
      _locationController.text = widget.calendar!.location;
      _descriptionController.text = widget.calendar!.description;
      _imageUrlController.text = widget.calendar!.imageUrl ?? '';
      _isActive = widget.calendar!.isActive;
      
      // Initialize variety controllers
      for (var variety in widget.calendar!.recommendedVarieties) {
        final controller = TextEditingController(text: variety);
        _varietyControllers.add(controller);
      }
      
      // Initialize care tip controllers
      for (var tip in widget.calendar!.careTips) {
        final controller = TextEditingController(text: tip);
        _careTipControllers.add(controller);
      }
    } else {
      // Add one empty variety and care tip for new calendar
      _varietyControllers.add(TextEditingController());
      _careTipControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _cropNameController.dispose();
    _cropTypeController.dispose();
    _plantingMonthController.dispose();
    _harvestMonthController.dispose();
    _plantingDurationController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    for (var controller in _varietyControllers) {
      controller.dispose();
    }
    for (var controller in _careTipControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveCalendar() async {
    if (!_formKey.currentState!.validate()) return;

    final varieties = _varietyControllers
        .map((c) => c.text.trim())
        .where((v) => v.isNotEmpty)
        .toList();
    
    final careTips = _careTipControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final calendar = PlantingCalendarModel(
      id: widget.calendar?.id ?? '',
      cropName: _cropNameController.text.trim(),
      cropType: _cropTypeController.text.trim(),
      plantingMonth: _plantingMonthController.text.trim(),
      harvestMonth: _harvestMonthController.text.trim(),
      plantingDuration: int.tryParse(_plantingDurationController.text.trim()) ?? 0,
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      recommendedVarieties: varieties,
      careTips: careTips,
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      isActive: _isActive,
      createdAt: widget.calendar?.createdAt ?? DateTime.now(),
      createdBy: widget.calendar?.createdBy ?? '',
    );

    if (widget.calendar == null) {
      await _controller.createCalendar(calendar);
    } else {
      await _controller.updateCalendar(calendar);
    }

    if (mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.calendar != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(isEdit ? 'Edit Kalender Tanam' : 'Tambah Kalender Tanam'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Crop Name
              TextFormField(
                controller: _cropNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Tanaman',
                  prefixIcon: Icon(Iconsax.text),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tanaman tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Crop Type
              DropdownButtonFormField<String>(
                value: _cropTypeController.text.isEmpty ? null : _cropTypeController.text,
                decoration: const InputDecoration(
                  labelText: 'Jenis Tanaman',
                  prefixIcon: Icon(Iconsax.category),
                ),
                items: cropTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
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
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Planting Month
              DropdownButtonFormField<String>(
                value: _plantingMonthController.text.isEmpty ? null : _plantingMonthController.text,
                decoration: const InputDecoration(
                  labelText: 'Bulan Tanam',
                  prefixIcon: Icon(Iconsax.calendar_1),
                ),
                items: months.map((month) {
                  return DropdownMenuItem(value: month, child: Text(month));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _plantingMonthController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bulan tanam harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Harvest Month
              DropdownButtonFormField<String>(
                value: _harvestMonthController.text.isEmpty ? null : _harvestMonthController.text,
                decoration: const InputDecoration(
                  labelText: 'Bulan Panen',
                  prefixIcon: Icon(Iconsax.timer),
                ),
                items: months.map((month) {
                  return DropdownMenuItem(value: month, child: Text(month));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _harvestMonthController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bulan panen harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Planting Duration
              TextFormField(
                controller: _plantingDurationController,
                decoration: const InputDecoration(
                  labelText: 'Durasi Tanam (hari)',
                  prefixIcon: Icon(Iconsax.clock),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Durasi tanam tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Durasi harus berupa angka';
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

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (Opsional)',
                  prefixIcon: Icon(Iconsax.image),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Recommended Varieties
              Text(
                'Varietas yang Direkomendasikan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._varietyControllers.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            hintText: 'Varietas ${entry.key + 1}',
                            prefixIcon: const Icon(Iconsax.tick_circle),
                          ),
                        ),
                      ),
                      if (_varietyControllers.length > 1)
                        IconButton(
                          icon: const Icon(Iconsax.trash, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              entry.value.dispose();
                              _varietyControllers.removeAt(entry.key);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _varietyControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(Iconsax.add),
                label: const Text('Tambah Varietas'),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Care Tips
              Text(
                'Tips Perawatan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._careTipControllers.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            hintText: 'Tip ${entry.key + 1}',
                            prefixIcon: const Icon(Iconsax.info_circle),
                          ),
                          maxLines: 2,
                        ),
                      ),
                      if (_careTipControllers.length > 1)
                        IconButton(
                          icon: const Icon(Iconsax.trash, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              entry.value.dispose();
                              _careTipControllers.removeAt(entry.key);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _careTipControllers.add(TextEditingController());
                  });
                },
                icon: const Icon(Iconsax.add),
                label: const Text('Tambah Tip'),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Active Status
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Kalender akan ditampilkan ke user'),
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
                child: Obx(
                  () => ElevatedButton(
                    onPressed: _controller.isSaving.value ? null : _saveCalendar,
                    child: _controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? 'Simpan Perubahan' : 'Buat Kalender'),
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

