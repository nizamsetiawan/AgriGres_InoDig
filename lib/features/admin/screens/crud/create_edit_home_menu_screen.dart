import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/home_menu_management_controller.dart';
import 'package:agrigres/features/detection/models/home_menu_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';
import 'package:agrigres/utils/helpers/icon_helper.dart';

class CreateEditHomeMenuScreen extends StatefulWidget {
  final HomeMenuModel? menu; // null for create, not null for edit

  const CreateEditHomeMenuScreen({Key? key, this.menu}) : super(key: key);

  @override
  State<CreateEditHomeMenuScreen> createState() => _CreateEditHomeMenuScreenState();
}

class _CreateEditHomeMenuScreenState extends State<CreateEditHomeMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _routeController = TextEditingController();
  final _iconNameController = TextEditingController();
  final _orderController = TextEditingController();
  final _controller = Get.find<HomeMenuManagementController>();
  bool _isLoading = false;
  bool _isActive = true;

  // Color pickers
  Color _backgroundColor = Colors.blue[100]!;
  Color _iconColor = Colors.blue[600]!;

  // Available routes
  final List<String> _availableRoutes = [
    '/agri-info',
    '/agri-edu',
    '/agri-care',
    '/agri-mart',
    '/planting-calendar',
    '/farm-management',
    '/calculator',
    '/farmer-forum',
    '/guidelines',
    '/settings',
  ];

  // Available icons
  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'info_outline', 'icon': Icons.info_outline},
    {'name': 'school_outlined', 'icon': Icons.school_outlined},
    {'name': 'health_and_safety_outlined', 'icon': Icons.health_and_safety_outlined},
    {'name': 'store_outlined', 'icon': Icons.store_outlined},
    {'name': 'calendar_today_outlined', 'icon': Icons.calendar_today_outlined},
    {'name': 'agriculture_outlined', 'icon': Icons.agriculture_outlined},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'settings', 'icon': Icons.settings},
    {'name': 'person', 'icon': Icons.person},
    {'name': 'notifications', 'icon': Icons.notifications},
    {'name': 'search', 'icon': Icons.search},
    {'name': 'camera', 'icon': Icons.camera_alt},
    {'name': 'image', 'icon': Icons.image},
    {'name': 'article', 'icon': Icons.article},
    {'name': 'forum', 'icon': Icons.forum},
    {'name': 'calculator', 'icon': Icons.calculate},
    {'name': 'chart', 'icon': Icons.bar_chart},
    {'name': 'map', 'icon': Icons.map},
    {'name': 'location', 'icon': Icons.location_on},
    {'name': 'weather', 'icon': Icons.wb_sunny},
    {'name': 'farm', 'icon': Icons.agriculture},
    {'name': 'plant', 'icon': Icons.local_florist},
    {'name': 'leaf', 'icon': Icons.eco},
    {'name': 'water', 'icon': Icons.water_drop},
    {'name': 'fertilizer', 'icon': Icons.science},
    {'name': 'shopping', 'icon': Icons.shopping_cart},
    {'name': 'education', 'icon': Icons.school},
    {'name': 'care', 'icon': Icons.medical_services},
    {'name': 'info', 'icon': Icons.info},
    {'name': 'market', 'icon': Icons.store},
    {'name': 'calendar', 'icon': Icons.calendar_month},
    {'name': 'management', 'icon': Icons.manage_accounts},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.menu != null) {
      _titleController.text = widget.menu!.title;
      _subtitleController.text = widget.menu!.subtitle;
      _routeController.text = widget.menu!.route;
      _iconNameController.text = widget.menu!.iconName;
      _orderController.text = widget.menu!.order.toString();
      _isActive = widget.menu!.isActive;
      _backgroundColor = IconHelper.intToColor(widget.menu!.backgroundColor);
      _iconColor = IconHelper.intToColor(widget.menu!.iconColor);
    } else {
      _orderController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _routeController.dispose();
    _iconNameController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _saveMenu() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = int.tryParse(_orderController.text.trim()) ?? 0;
      final formattedTitle = _ensureAgriPrefix(_titleController.text.trim());
      if (_titleController.text.trim() != formattedTitle) {
        _titleController.text = formattedTitle;
      }

      final menu = HomeMenuModel(
        id: widget.menu?.id ?? '',
        title: formattedTitle,
        subtitle: _subtitleController.text.trim(),
        route: _routeController.text.trim(),
        iconName: _iconNameController.text.trim(),
        backgroundColor: IconHelper.colorToInt(_backgroundColor),
        iconColor: IconHelper.colorToInt(_iconColor),
        order: order,
        isActive: _isActive,
      );

      if (widget.menu == null) {
        // Create new
        await _controller.createMenu(menu);
      } else {
        // Update existing
        await _controller.updateMenu(widget.menu!.id, menu);
      }
      Get.back();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Kesalahan',
        message: 'Gagal menyimpan menu: ${e.toString()}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _ensureAgriPrefix(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return 'AgriMenu';
    if (trimmed.toLowerCase().startsWith('agri')) return trimmed;
    final capitalized =
        trimmed[0].toUpperCase() + (trimmed.length > 1 ? trimmed.substring(1) : '');
    return 'Agri$capitalized';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: Text(widget.menu == null ? 'Tambah Menu' : 'Edit Menu'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            IconHelper.getIconFromName(_iconNameController.text) ?? Icons.help_outline,
                            color: _iconColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _titleController.text.isEmpty ? 'Judul Menu' : _titleController.text,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _subtitleController.text.isEmpty ? 'Deskripsi menu' : _subtitleController.text,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Menu',
                  hintText: 'Contoh: AgriInfo',
                  helperText: 'Disarankan selalu diawali "Agri" agar konsisten di beranda.',
                  prefixIcon: Icon(Iconsax.tag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul menu tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Subtitle
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Contoh: Informasi harga pangan harian',
                  prefixIcon: Icon(Iconsax.document_text),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Route
              DropdownButtonFormField<String>(
                value: _availableRoutes.contains(_routeController.text) ? _routeController.text : null,
                decoration: const InputDecoration(
                  labelText: 'Route',
                  hintText: 'Pilih route',
                  prefixIcon: Icon(Iconsax.route_square),
                ),
                items: _availableRoutes.map((route) {
                  return DropdownMenuItem(
                    value: route,
                    child: Text(route),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _routeController.text = value;
                    setState(() {});
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Route harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Icon Name
              DropdownButtonFormField<String>(
                value: _availableIcons.any((icon) => icon['name'] == _iconNameController.text)
                    ? _iconNameController.text
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Icon',
                  hintText: 'Pilih icon',
                  prefixIcon: Icon(Iconsax.image),
                ),
                items: _availableIcons.map((icon) {
                  return DropdownMenuItem(
                    value: icon['name'] as String,
                    child: Row(
                      children: [
                        Icon(icon['icon'] as IconData, size: 20),
                        const SizedBox(width: 8),
                        Text(icon['name'] as String),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _iconNameController.text = value;
                    setState(() {});
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Icon harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Background Color
              ListTile(
                title: const Text('Warna Latar Belakang'),
                subtitle: Text('${_backgroundColor.value.toRadixString(16)}'),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final color = await showDialog<Color>(
                      context: context,
                      builder: (context) => _ColorPickerDialog(initialColor: _backgroundColor),
                    );
                    if (color != null) {
                      setState(() {
                        _backgroundColor = color;
                      });
                    }
                  },
                  child: const Text('Pilih Warna'),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Icon Color
              ListTile(
                title: const Text('Warna Icon'),
                subtitle: Text('${_iconColor.value.toRadixString(16)}'),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final color = await showDialog<Color>(
                      context: context,
                      builder: (context) => _ColorPickerDialog(initialColor: _iconColor),
                    );
                    if (color != null) {
                      setState(() {
                        _iconColor = color;
                      });
                    }
                  },
                  child: const Text('Pilih Warna'),
                ),
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

              // Is Active
              SwitchListTile(
                title: const Text('Aktif'),
                subtitle: const Text('Menu akan ditampilkan jika aktif'),
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
                  onPressed: _isLoading ? null : _saveMenu,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.menu == null ? 'Simpan' : 'Perbarui'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Simple Color Picker Dialog
class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  final List<Color> _presetColors = [
    Colors.blue[100]!,
    Colors.blue[600]!,
    Colors.orange[100]!,
    Colors.orange[600]!,
    Colors.green[100]!,
    Colors.green[600]!,
    Colors.pink[100]!,
    Colors.pink[600]!,
    Colors.teal[100]!,
    Colors.teal[600]!,
    Colors.brown[100]!,
    Colors.brown[600]!,
    Colors.purple[100]!,
    Colors.purple[600]!,
    Colors.red[100]!,
    Colors.red[600]!,
    Colors.yellow[100]!,
    Colors.yellow[600]!,
    Colors.indigo[100]!,
    Colors.indigo[600]!,
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pilih Warna'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Preset Colors
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetColors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.black : Colors.grey[300]!,
                        width: _selectedColor == color ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Color Preview
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Text(
                  '#${_selectedColor.value.toRadixString(16).toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedColor),
          child: const Text('Pilih'),
        ),
      ],
    );
  }
}

