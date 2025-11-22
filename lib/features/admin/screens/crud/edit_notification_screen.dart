import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/notifications_management_controller.dart';
import 'package:agrigres/features/notification/models/notification_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class EditNotificationScreen extends StatefulWidget {
  final NotificationModel notification;

  const EditNotificationScreen({Key? key, required this.notification}) : super(key: key);

  @override
  State<EditNotificationScreen> createState() => _EditNotificationScreenState();
}

class _EditNotificationScreenState extends State<EditNotificationScreen> {
  final _controller = Get.find<NotificationsManagementController>();
  late String _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.notification.status;
  }

  Future<void> _saveStatus() async {
    if (_selectedStatus == widget.notification.status) {
      Get.back();
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _controller.updateNotificationStatus(widget.notification.id, _selectedStatus);
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Status notifikasi berhasil diperbarui',
      );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Sedang Diproses';
      case 'resolved':
        return 'Selesai';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: const Text('Ubah Status Notifikasi'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notification.jenisDarurat,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pelapor: ${widget.notification.namaPelapor}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Lokasi: ${widget.notification.lokasiLahan}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Status Selection
            Text(
              'Pilih Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Status Options
            ...['pending', 'processing', 'resolved'].map((status) {
              final isSelected = _selectedStatus == status;
              final statusColor = _getStatusColor(status);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? statusColor : Colors.grey[200]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: RadioListTile<String>(
                  title: Text(_getStatusLabel(status)),
                  value: status,
                  groupValue: _selectedStatus,
                  activeColor: statusColor,
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                ),
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveStatus,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

