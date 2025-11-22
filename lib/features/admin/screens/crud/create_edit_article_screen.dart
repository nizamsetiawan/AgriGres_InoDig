import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/common/widgets/appbar/appbar.dart';
import 'package:agrigres/features/admin/controllers/articles_management_controller.dart';
import 'package:agrigres/features/article/models/article_model.dart';
import 'package:agrigres/utils/constraints/sizes.dart';
import 'package:agrigres/utils/helpers/loaders.dart';

class CreateEditArticleScreen extends StatefulWidget {
  final ArticleModel? article; // null for create, not null for edit

  const CreateEditArticleScreen({Key? key, this.article}) : super(key: key);

  @override
  State<CreateEditArticleScreen> createState() => _CreateEditArticleScreenState();
}

class _CreateEditArticleScreenState extends State<CreateEditArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _controller = Get.find<ArticlesManagementController>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      // Edit mode - populate fields
      _titleController.text = widget.article!.title;
      _categoryController.text = widget.article!.category;
      _authorController.text = widget.article!.author;
      _contentController.text = widget.article!.content;
      _imageUrlController.text = widget.article!.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveArticle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.article == null) {
        // Create new article
        final article = ArticleModel(
          title: _titleController.text.trim(),
          category: _categoryController.text.trim(),
          author: _authorController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          createdAt: DateTime.now().toIso8601String(),
        );
        await _controller.createArticle(article);
        TLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Artikel berhasil dibuat',
        );
      } else {
        // Update existing article
        final updatedArticle = ArticleModel(
          id: widget.article!.id,
          title: _titleController.text.trim(),
          category: _categoryController.text.trim(),
          author: _authorController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          createdAt: widget.article!.createdAt,
        );
        await _controller.updateArticle(widget.article!.id, updatedArticle);
        TLoaders.successSnackBar(
          title: 'Berhasil',
          message: 'Artikel berhasil diperbarui',
        );
      }
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
        title: Text(widget.article == null ? 'Tambah Artikel' : 'Edit Artikel'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: Icon(Iconsax.category),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Author
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Penulis',
                  prefixIcon: Icon(Iconsax.user),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Penulis tidak boleh kosong';
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
                  onPressed: _isLoading ? null : _saveArticle,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.article == null ? 'Simpan Artikel' : 'Perbarui Artikel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

