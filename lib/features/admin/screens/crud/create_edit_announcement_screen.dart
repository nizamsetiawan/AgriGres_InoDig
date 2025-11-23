import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/announcements_management_controller.dart';
import 'package:agrigres/features/admin/models/announcement_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:intl/intl.dart';

class CreateEditAnnouncementScreen extends StatefulWidget {
  final AnnouncementModel? announcement;

  const CreateEditAnnouncementScreen({
    Key? key,
    this.announcement,
  }) : super(key: key);

  @override
  State<CreateEditAnnouncementScreen> createState() => _CreateEditAnnouncementScreenState();
}

class _CreateEditAnnouncementScreenState extends State<CreateEditAnnouncementScreen> {
  final _controller = Get.find<AnnouncementsManagementController>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  String _selectedType = 'announcement';
  bool _isActive = true;
  DateTime? _expiresAt;

  @override
  void initState() {
    super.initState();
    if (widget.announcement != null) {
      _titleController.text = widget.announcement!.title;
      _contentController.text = widget.announcement!.content;
      _imageUrlController.text = widget.announcement!.imageUrl ?? '';
      _selectedType = widget.announcement!.type;
      _isActive = widget.announcement!.isActive;
      _expiresAt = widget.announcement!.expiresAt;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_expiresAt ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _expiresAt = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    final announcement = AnnouncementModel(
      id: widget.announcement?.id ?? '',
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      type: _selectedType,
      isActive: _isActive,
      createdAt: widget.announcement?.createdAt ?? DateTime.now(),
      expiresAt: _expiresAt,
      createdBy: widget.announcement?.createdBy ?? '',
    );

    if (widget.announcement == null) {
      await _controller.createAnnouncement(announcement);
    } else {
      await _controller.updateAnnouncement(announcement);
    }

    if (mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.announcement != null;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(isEdit ? 'Edit Pengumuman' : 'Tambah Pengumuman'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selection
              Text(
                'Tipe Pengumuman',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeChip('announcement', 'Pengumuman', Iconsax.notification),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTypeChip('update', 'Pembaruan', Iconsax.refresh),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTypeChip('feature', 'Fitur Baru', Iconsax.star),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  prefixIcon: Icon(Iconsax.text),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Content
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Konten',
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Konten tidak boleh kosong';
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

              // Expiry Date
              InkWell(
                onTap: _selectExpiryDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.calendar),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Kedaluwarsa (Opsional)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _expiresAt != null
                                  ? dateFormat.format(_expiresAt!)
                                  : 'Tidak ada',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (_expiresAt != null)
                        IconButton(
                          icon: const Icon(Iconsax.close_circle, size: 20),
                          onPressed: () {
                            setState(() {
                              _expiresAt = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Active Status
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Pengumuman akan ditampilkan ke user'),
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
                    onPressed: _controller.isSaving.value ? null : _saveAnnouncement,
                    child: _controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? 'Simpan Perubahan' : 'Buat Pengumuman'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

