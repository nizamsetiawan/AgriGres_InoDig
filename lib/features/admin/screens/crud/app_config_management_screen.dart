import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/app_config_management_controller.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class AppConfigManagementScreen extends StatefulWidget {
  const AppConfigManagementScreen({Key? key}) : super(key: key);

  @override
  State<AppConfigManagementScreen> createState() => _AppConfigManagementScreenState();
}

class _AppConfigManagementScreenState extends State<AppConfigManagementScreen> {
  final _controller = Get.put(AppConfigManagementController());
  final Map<String, TextEditingController> _controllers = {};
  final _newKeyController = TextEditingController();
  final _newValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers when config data is loaded
    _controller.configData.listen((config) {
      if (mounted) {
        _initializeControllers(config);
      }
    });
  }

  void _initializeControllers(Map<String, String> config) {
    // Dispose old controllers that are no longer in config
    final keysToRemove = _controllers.keys.where((key) => !config.containsKey(key)).toList();
    for (var key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
    }

    // Create new controllers for new keys
    for (var entry in config.entries) {
      if (!_controllers.containsKey(entry.key)) {
        _controllers[entry.key] = TextEditingController(text: entry.value);
      } else {
        // Update existing controller if value changed
        if (_controllers[entry.key]!.text != entry.value) {
          _controllers[entry.key]!.text = entry.value;
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _newKeyController.dispose();
    _newValueController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    final updatedConfig = <String, String>{};
    for (var entry in _controllers.entries) {
      updatedConfig[entry.key] = entry.value.text.trim();
    }
    await _controller.updateConfig(updatedConfig);
  }

  void _addNewKey() {
    if (_newKeyController.text.trim().isEmpty) {
      TLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Key tidak boleh kosong',
      );
      return;
    }

    if (_controllers.containsKey(_newKeyController.text.trim())) {
      TLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Key sudah ada',
      );
      return;
    }

    setState(() {
      _controllers[_newKeyController.text.trim()] =
          TextEditingController(text: _newValueController.text.trim());
      _controller.addConfigKey(
        _newKeyController.text.trim(),
        _newValueController.text.trim(),
      );
      _newKeyController.clear();
      _newValueController.clear();
    });
  }

  void _removeKey(String key) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus key "$key"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _controllers[key]?.dispose();
                _controllers.remove(key);
                _controller.removeConfigKey(key);
              });
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: const Text('Manajemen Konfigurasi'),
        showBackArrow: true,
        actions: [
          Obx(
            () => IconButton(
              icon: _controller.isSaving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Iconsax.refresh),
              onPressed: _controller.isSaving.value ? null : () => _controller.loadConfig(),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Konfigurasi aplikasi (API keys, URLs, dll). Perubahan akan diterapkan setelah refresh.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[900],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Add New Key Section
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
                        'Tambah Key Baru',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextField(
                        controller: _newKeyController,
                        decoration: const InputDecoration(
                          labelText: 'Key',
                          prefixIcon: Icon(Iconsax.key),
                          hintText: 'Contoh: NEW_API_KEY',
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextField(
                        controller: _newValueController,
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          prefixIcon: Icon(Iconsax.code),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addNewKey,
                          icon: const Icon(Iconsax.add),
                          label: const Text('Tambah Key'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // Config Keys List
                Text(
                  'Konfigurasi (${_controller.configData.length} keys)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                ..._controller.configData.entries.map((entry) {
                  if (!_controllers.containsKey(entry.key)) {
                    _controllers[entry.key] = TextEditingController(text: entry.value);
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, size: 18, color: Colors.red),
                                    onPressed: () => _removeKey(entry.key),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _controllers[entry.key],
                                decoration: InputDecoration(
                                  hintText: 'Value',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                maxLines: null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: TSizes.spaceBtwSections),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _controller.isSaving.value ? null : _saveConfig,
                    child: _controller.isSaving.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan Konfigurasi'),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

