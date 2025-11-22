import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/forum_posts_management_controller.dart';
import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class EditForumPostScreen extends StatefulWidget {
  final ForumPostModel post;

  const EditForumPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<EditForumPostScreen> createState() => _EditForumPostScreenState();
}

class _EditForumPostScreenState extends State<EditForumPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _controller = Get.find<ForumPostsManagementController>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.post.content;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedPost = ForumPostModel(
        id: widget.post.id,
        userId: widget.post.userId,
        userName: widget.post.userName,
        userImageUrl: widget.post.userImageUrl,
        content: _contentController.text.trim(),
        imageUrl: widget.post.imageUrl,
        imageUrls: widget.post.imageUrls,
        location: widget.post.location,
        tags: widget.post.tags,
        isAnonymous: widget.post.isAnonymous,
        disableComments: widget.post.disableComments,
        likes: widget.post.likes,
        comments: widget.post.comments,
        createdAt: widget.post.createdAt,
        updatedAt: DateTime.now(),
      );
      await _controller.updatePost(updatedPost);
      TLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Postingan berhasil diperbarui',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: TAppBar(
        title: const Text('Edit Postingan'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info (read-only)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Iconsax.user, color: Colors.green[600], size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.isAnonymous ? 'Anonymous' : widget.post.userName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.post.userId,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Content
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Konten',
                  prefixIcon: Icon(Iconsax.document_text),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Konten tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePost,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Perbarui Postingan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

