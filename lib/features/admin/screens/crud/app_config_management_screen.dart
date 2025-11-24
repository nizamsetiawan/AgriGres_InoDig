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
  final Map<String, bool> _obscureTextMap = {}; // Track obscure state for each key
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
    if (!mounted) return;
    
    // Dispose old controllers that are no longer in config
    final keysToRemove = _controllers.keys.where((key) => !config.containsKey(key)).toList();
    for (var key in keysToRemove) {
      _controllers[key]?.dispose();
      _controllers.remove(key);
      _obscureTextMap.remove(key);
    }

    // Create new controllers for new keys
    for (var entry in config.entries) {
      if (!_controllers.containsKey(entry.key)) {
        _controllers[entry.key] = TextEditingController(text: entry.value);
        // Set initial obscure state for API keys and secrets
        _obscureTextMap[entry.key] = entry.key.toUpperCase().contains('API_KEY') || 
                                     entry.key.toUpperCase().contains('SECRET');
      } else {
        // Update existing controller if value changed
        if (_controllers[entry.key]!.text != entry.value) {
          _controllers[entry.key]!.text = entry.value;
        }
      }
    }
    
    // Trigger rebuild jika mounted
    if (mounted) {
      setState(() {});
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
    // Reload config setelah save untuk memastikan data terbaru
    await _controller.loadConfig();
    // Re-initialize controllers dengan data terbaru
    if (mounted) {
      _initializeControllers(_controller.configData);
    }
  }

  Future<void> _addNewKey() async {
    if (_newKeyController.text.trim().isEmpty) {
      TLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Key tidak boleh kosong',
      );
      return;
    }

    final key = _newKeyController.text.trim();
    final value = _newValueController.text.trim();
    
    if (_controllers.containsKey(key)) {
      TLoaders.warningSnackBar(
        title: 'Peringatan',
        message: 'Key sudah ada',
      );
      return;
    }

    setState(() {
      _controllers[key] = TextEditingController(text: value);
      _controller.addConfigKey(key, value);
      // Set initial obscure state for API keys and secrets
      _obscureTextMap[key] = key.toUpperCase().contains('API_KEY') || 
                             key.toUpperCase().contains('SECRET');
      _newKeyController.clear();
      _newValueController.clear();
    });

    // Auto-save ke Firebase
    try {
      final updatedConfig = <String, String>{};
      for (var entry in _controllers.entries) {
        updatedConfig[entry.key] = entry.value.text.trim();
      }
      await _controller.updateConfig(updatedConfig);
      // Reload untuk memastikan data terbaru
      await _controller.loadConfig();
      // Re-initialize controllers dengan data terbaru
      if (mounted) {
        _initializeControllers(_controller.configData);
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menyimpan key baru: ${e.toString()}',
      );
    }
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
            onPressed: () async {
              setState(() {
                _controllers[key]?.dispose();
                _controllers.remove(key);
                _obscureTextMap.remove(key);
                _controller.removeConfigKey(key);
              });
              Get.back();
              
              // Auto-save ke Firebase setelah hapus
              try {
                final updatedConfig = <String, String>{};
                for (var entry in _controllers.entries) {
                  updatedConfig[entry.key] = entry.value.text.trim();
                }
                await _controller.updateConfig(updatedConfig);
                // Reload untuk memastikan data terbaru
                await _controller.loadConfig();
              } catch (e) {
                TLoaders.errorSnackBar(
                  title: 'Kesalahan',
                  message: 'Gagal menghapus key: ${e.toString()}',
                );
              }
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
              icon: _controller.isSaving.value || _controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Iconsax.refresh),
              onPressed: (_controller.isSaving.value || _controller.isLoading.value) 
                  ? null 
                  : () async {
                      await _controller.loadConfig();
                      // Re-initialize controllers setelah reload
                      _initializeControllers(_controller.configData);
                    },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.dollar_circle, color: Colors.orange[700], size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'BADAN_PANGAN_API_KEY: Daftar di webapi.badanpangan.go.id untuk mendapatkan API key',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.orange[900],
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
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
                      // Quick Add Presets
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildQuickAddChip(
                            context,
                            'BADAN_PANGAN_API_KEY',
                            'API Key Badan Pangan',
                            () {
                              _newKeyController.text = 'BADAN_PANGAN_API_KEY';
                              _newValueController.clear();
                            },
                          ),
                          _buildQuickAddChip(
                            context,
                            'GEMINI_API_KEY',
                            'API Key Gemini',
                            () {
                              _newKeyController.text = 'GEMINI_API_KEY';
                              _newValueController.clear();
                            },
                          ),
                          _buildQuickAddChip(
                            context,
                            'YOUTUBE_API_KEY',
                            'API Key YouTube',
                            () {
                              _newKeyController.text = 'YOUTUBE_API_KEY';
                              _newValueController.clear();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextField(
                        controller: _newKeyController,
                        decoration: const InputDecoration(
                          labelText: 'Key',
                          prefixIcon: Icon(Iconsax.key),
                          hintText: 'Contoh: BADAN_PANGAN_API_KEY',
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                      TextField(
                        controller: _newValueController,
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          prefixIcon: Icon(Iconsax.code),
                          hintText: 'Masukkan nilai API key',
                        ),
                        obscureText: true,
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
                  // Initialize controller if not exists
                  if (!_controllers.containsKey(entry.key)) {
                    _controllers[entry.key] = TextEditingController(text: entry.value);
                    // Set initial obscure state for API keys and secrets
                    _obscureTextMap[entry.key] = entry.key.toUpperCase().contains('API_KEY') || 
                                                 entry.key.toUpperCase().contains('SECRET');
                  } else {
                    // Update controller value if it changed in configData
                    if (_controllers[entry.key]!.text != entry.value) {
                      _controllers[entry.key]!.text = entry.value;
                    }
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
                                  suffixIcon: entry.key.toUpperCase().contains('API_KEY') || 
                                             entry.key.toUpperCase().contains('SECRET')
                                      ? IconButton(
                                          icon: Icon(
                                            _obscureTextMap[entry.key] == true
                                                ? Iconsax.eye_slash
                                                : Iconsax.eye,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureTextMap[entry.key] = 
                                                  !(_obscureTextMap[entry.key] ?? true);
                                            });
                                          },
                                        )
                                      : null,
                                ),
                                obscureText: _obscureTextMap[entry.key] ?? false,
                                maxLines: entry.key.toUpperCase().contains('API_KEY') || 
                                         entry.key.toUpperCase().contains('SECRET') ? 1 : null,
                              ),
                              // Show info for Badan Pangan API Key
                              if (entry.key == 'BADAN_PANGAN_API_KEY')
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Icon(Iconsax.info_circle, size: 12, color: Colors.blue[600]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Daftar di webapi.badanpangan.go.id untuk mendapatkan API key',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.blue[700],
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Widget _buildQuickAddChip(
    BuildContext context,
    String key,
    String label,
    VoidCallback onTap,
  ) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11),
      ),
      onPressed: onTap,
      avatar: const Icon(Iconsax.key, size: 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

