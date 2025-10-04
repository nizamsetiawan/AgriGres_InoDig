import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/forum/controllers/forum_controller.dart';
import 'package:agrigres/features/forum/utils/tag_colors.dart';
import 'package:agrigres/features/detection/controllers/location_controller.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/common/widgets/loaders/shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<File> _selectedImages = [];
  bool _isUploadingImage = false;
  List<String> _uploadedImageUrls = [];
  String? _locationText;
  StreamSubscription<String>? _locationSubscription;
  
  // Post options
  bool _isAnonymous = false;
  bool _disableComments = false;
  bool _hideLocation = false;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<ForumController>();
    controller.postContentController.addListener(_onTextChanged);
    
    // Set up location listener
    _setupLocationListener();
  }
  
  void _setupLocationListener() {
    try {
      final locationController = Get.find<GeoTaggingController>();
      _locationSubscription = locationController.strLocation.listen((location) {
        if (location.isNotEmpty && 
            location != 'Mencari lokasi...' && 
            location != 'Error fetching address' &&
            location != 'Alamat tidak ditemukan' &&
            !location.contains('Error')) {
          setState(() {
            _locationText = location;
          });
        }
      });
    } catch (e) {
      print('Error setting up location listener: $e');
    }
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _pickImage() {
    _showImagePicker();
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Pilih Sumber Gambar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: TColors.primary),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: TColors.primary),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                _pickImageFromCamera();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((image) => File(image.path)));
        });
        await _uploadImages();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
        await _uploadImages();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo: $e');
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      // Upload to Cloudinary using ForumController
      final controller = Get.find<ForumController>();
      final imagePaths = _selectedImages.map((file) => file.path).toList();
      final uploadedUrls = await controller.uploadImages(imagePaths);
      
      if (uploadedUrls.isNotEmpty) {
        setState(() {
          _uploadedImageUrls = uploadedUrls;
          _isUploadingImage = false;
        });
        Get.snackbar('Success', 'Gambar Berhasil diUpload', snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,);

      } else {
        setState(() {
          _isUploadingImage = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      Get.snackbar('Error', 'Gagal Upload Gambar', snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationController = Get.find<GeoTaggingController>();
      
      // Check if location is already available and valid
      String currentLocation = locationController.strLocation.value;
      if (currentLocation.isNotEmpty && 
          currentLocation != 'Mencari lokasi...' && 
          currentLocation != 'Error fetching address' &&
          currentLocation != 'Alamat tidak ditemukan' &&
          !currentLocation.contains('Error')) {
        setState(() {
          _locationText = currentLocation;
        });
        return;
      }
      
      // If location is not available, fetch it
      locationController.fetchGeoLocation();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    }
  }

  @override
  void dispose() {
    final controller = Get.find<ForumController>();
    controller.postContentController.removeListener(_onTextChanged);
    _locationSubscription?.cancel();
    super.dispose();
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: iconColor.withOpacity(0.3)),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: value ? TColors.primary : Colors.grey[400]!,
                  width: 2,
                ),
                color: value ? TColors.primary : Colors.transparent,
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerButton() {
    return TShimmerEffect(
      width: 80,
      height: 32,
      radius: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForumController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Buat Postingan'),
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: controller.forumRepository.userController.user.value.profilePicture.isNotEmpty
                        ? NetworkImage(controller.forumRepository.userController.user.value.profilePicture)
                        : null,
                    child: controller.forumRepository.userController.user.value.profilePicture.isEmpty
                        ? Icon(Icons.person, color: Colors.grey[600], size: 18)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.forumRepository.userController.user.value.fullName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Bagikan pengalaman bertani Anda',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Content Input Card
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
                  TextField(
                    controller: controller.postContentController,
                    maxLines: 6,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: 'Apa yang terjadi di lahan Anda hari ini?',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Character Count
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${controller.postContentController.text.length}/500',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tags Input Card
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
                  Row(
                    children: [
                      Icon(
                        Icons.tag,
                        color: TColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tags (Opsional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Tag Input
                  TextField(
                    controller: controller.tagController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan tag (contoh: jagung panen)',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: TColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (controller.tagController.text.trim().isNotEmpty) {
                            controller.addTag(controller.tagController.text.trim());
                          }
                        },
                        icon: Icon(
                          Icons.add,
                          color: TColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 12),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        controller.addTag(value.trim());
                      }
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Selected Tags
                  Obx(() {
                    if (controller.selectedTags.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.selectedTags.asMap().entries.map((entry) {
                        final index = entry.key;
                        final tag = entry.value;
                        
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TagColors.getBackgroundColor(index),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TagColors.getBorderColor(index),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '#$tag',
                                style: TextStyle(
                                  color: TagColors.getTextColor(index),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => controller.removeTag(tag),
                                child: Icon(
                                  Icons.close,
                                  color: TagColors.getTextColor(index),
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Post Options Card
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
                  Row(
                    children: [
                      Icon(Icons.settings_outlined, color: TColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Opsi Postingan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Anonymous Option
                  _buildOptionTile(
                    icon: Icons.visibility_off_outlined,
                    title: 'Postingan Anonim',
                    subtitle: 'Nama Anda tidak akan ditampilkan',
                    value: _isAnonymous,
                    onChanged: (value) => setState(() => _isAnonymous = value!),
                    iconColor: Colors.purple,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Disable Comments Option
                  _buildOptionTile(
                    icon: Icons.block,
                    title: 'Nonaktifkan Komentar',
                    subtitle: 'Tidak ada yang bisa mengomentari postingan ini',
                    value: _disableComments,
                    onChanged: (value) => setState(() => _disableComments = value!),
                    iconColor: Colors.red,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Hide Location Option
                  _buildOptionTile(
                    icon: Icons.location_off_outlined,
                    title: 'Sembunyikan Lokasi',
                    subtitle: 'Lokasi tidak akan ditampilkan di postingan',
                    value: _hideLocation,
                    onChanged: (value) => setState(() => _hideLocation = value!),
                    iconColor: Colors.orange,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Upload Progress
            if (_isUploadingImage)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Obx(() {
                  final controller = Get.find<ForumController>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mengupload Gambar...',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Icon(
                            Icons.cloud_upload,
                            color: TColors.primary,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(controller.uploadProgress.value * 100).toInt()}% • ${(30 * (1 - controller.uploadProgress.value)).toInt()} detik tersisa',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: controller.uploadProgress.value,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
                      ),
                    ],
                  );
                }),
              ),

            // Selected Images Preview
            if (_selectedImages.isNotEmpty || _uploadedImageUrls.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.image, color: TColors.primary, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Gambar Terpilih (${_selectedImages.length})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.clear();
                                _uploadedImageUrls.clear();
                              });
                            },
                            child: Icon(Icons.close, color: Colors.grey[500], size: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(_selectedImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                      if (index < _uploadedImageUrls.length) {
                                        _uploadedImageUrls.removeAt(index);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red[600],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            
            // Location Preview
            if (_locationText != null && !_hideLocation)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: TColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _locationText!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _locationText = null;
                        });
                      },
                      child: Icon(Icons.close, color: Colors.grey[500], size: 16),
                    ),
                  ],
                ),
              ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  // Add Image Button
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TColors.primary.withOpacity(0.3)),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: TColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Add Location Button
                  Obx(() {
                    final locationController = Get.find<GeoTaggingController>();
                    final isLoading = locationController.loading.value;
                    
                    return GestureDetector(
                      onTap: isLoading ? null : _getCurrentLocation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isLoading 
                              ? Colors.grey[300] 
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isLoading 
                                ? Colors.grey[400]! 
                                : Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.orange[600],
                                ),
                              )
                            : Icon(
                                Icons.location_on_outlined,
                                color: Colors.orange[600],
                                size: 20,
                              ),
                      ),
                    );
                  }),
                  
                  const Spacer(),
                  
                  // Post Button
                  Obx(() => controller.isCreatingPost.value
                      ? _buildShimmerButton()
                      : ElevatedButton(
                          onPressed: () {
                            print('Creating post with location: $_locationText, hideLocation: $_hideLocation');
                            controller.createForumPost(
                              imageUrl: _uploadedImageUrls.isNotEmpty ? _uploadedImageUrls.first : null,
                              imageUrls: _uploadedImageUrls.isNotEmpty ? _uploadedImageUrls : null,
                              location: _hideLocation ? null : _locationText,
                              isAnonymous: _isAnonymous,
                              disableComments: _disableComments,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Posting',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
