import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/personalization/controllers/user_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final controller = Get.find<UserController>();
    firstNameController.text = controller.user.value.firstName;
    lastNameController.text = controller.user.value.lastName;
    phoneNumberController.text = controller.user.value.phoneNumber;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        showBackArrow: true,
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
                if (!isEditing) {
                  _initializeControllers(); // Reset to original values
                }
              });
            },
            icon: Icon(
              isEditing ? Icons.close : Icons.edit,
              color: TColors.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
              const SizedBox(height: 20),
              
              // Profile Avatar with Badge
              Obx(() => GestureDetector(
                onTap: () {
                  controller.uploadUserProfilePicture();
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: controller.user.value.profilePicture.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                controller.user.value.profilePicture,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar();
                                },
                              ),
                            )
                          : _buildDefaultAvatar(),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                    if (controller.imageUploading.value)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )),
              
              const SizedBox(height: 8),
              
              // Tap to change photo hint
              Text(
                'Ketuk foto untuk mengubah',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Form Fields
              _buildInputField(
                context,
                'Nama Depan',
                controller.user.value.firstName.isNotEmpty 
                    ? controller.user.value.firstName 
                    : 'Masukkan Nama Depan',
                isEnabled: isEditing,
                controller: firstNameController,
                hintText: 'Masukkan Nama Depan',
              ),
              
              const SizedBox(height: 16),
              
              _buildInputField(
                context,
                'Nama Belakang',
                controller.user.value.lastName.isNotEmpty 
                    ? controller.user.value.lastName 
                    : 'Masukkan Nama Belakang',
                isEnabled: isEditing,
                controller: lastNameController,
                hintText: 'Masukkan Nama Belakang',
              ),
              
              const SizedBox(height: 16),
              
              _buildInputField(
                context,
                'Username',
                controller.user.value.username.isNotEmpty 
                    ? controller.user.value.username 
                    : 'Masukkan Username',
                isEnabled: false,
              ),
              
              const SizedBox(height: 16),
              
              _buildInputField(
                context,
                'User ID',
                controller.user.value.id.isNotEmpty 
                    ? controller.user.value.id 
                    : '1239-12333-12343',
                isEnabled: false,
              ),
              
              const SizedBox(height: 16),
              
              _buildInputField(
                context,
                'Email',
                controller.user.value.email.isNotEmpty 
                    ? controller.user.value.email 
                    : 'takat89@gmail.com',
                isEnabled: false,
              ),
              
              const SizedBox(height: 16),
              
              _buildInputField(
                context,
                'Telp',
                controller.user.value.phoneNumber.isNotEmpty 
                    ? controller.user.value.phoneNumber 
                    : 'Masukkan Nomor Telp',
                isEnabled: isEditing,
                controller: phoneNumberController,
                hintText: 'Masukkan Nomor Telp',
              ),
              
              const SizedBox(height: 32),
              
              // Action Buttons
              if (isEditing) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                            _initializeControllers(); // Reset to original values
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.error,
                          side: const BorderSide(color: TColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Batalkan',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await controller.updateUserProfile(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              phoneNumber: phoneNumberController.text.trim(),
                            );
                            setState(() {
                              isEditing = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          side: const BorderSide(color: TColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      side: const BorderSide(color: TColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Kembali',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Text(
          '👨‍🌾',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context,
    String label,
    String value,
    {bool isEnabled = true,
    TextEditingController? controller,
    String? hintText}
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: isEnabled && controller != null
              ? TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Field ini wajib diisi';
                    }
                    return null;
                  },
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, 
                      vertical: 14,
                    ),
                    hintText: hintText,
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, 
                    vertical: 14,
                  ),
                  child: Text(
                    value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isEnabled ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
