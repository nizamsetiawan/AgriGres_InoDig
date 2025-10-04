import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/forum/controllers/forum_controller.dart';
import 'package:agrigres/features/forum/models/forum_post_model.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:intl/intl.dart';

class ForumPostCard extends StatelessWidget {
  const ForumPostCard({
    super.key,
    required this.post,
  });

  final ForumPostModel post;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForumController>();

    return GestureDetector(
      onTap: () => _showPostDetail(context, controller),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, controller),
            
            // Content
            _buildContent(context),
            
            // Location (if exists and not hidden)
            if (post.location != null && post.location!.isNotEmpty)
              _buildLocation(context),
            
            // Image (if exists)
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              _buildImage(context),
            
            // Actions
            _buildActions(context, controller),
            
            // Comments Preview - Only show if comments are not disabled
            if (post.comments.isNotEmpty && !post.disableComments)
              _buildCommentsPreview(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ForumController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[200],
            backgroundImage: post.userImageUrl.isNotEmpty
                ? NetworkImage(post.userImageUrl)
                : null,
            child: post.userImageUrl.isEmpty
                ? Icon(Icons.person, color: Colors.grey[500], size: 16)
                : null,
          ),
          
          const SizedBox(width: 12),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(post.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          // More Options (if owner)
          if (controller.isOwner(post.id))
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog(context, controller);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                ),
              ],
              child: Icon(
                Icons.more_vert,
                color: Colors.grey[500],
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        post.content,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildLocation(BuildContext context) {
    // Get only the first part of location (before first comma)
    String shortLocation = post.location!.split(',').first.trim();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.orange[600],
              size: 14,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                shortLocation,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        child: Image.network(
          post.imageUrl!,
          fit: BoxFit.cover,
          height: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: TColors.primary,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[500],
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat gambar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, ForumController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Like Button
          Obx(() => GestureDetector(
            onTap: () {
              controller.toggleLike(post.id);
            },
            child: Row(
              children: [
                Icon(
                  controller.isLiked(post.id) ? Icons.favorite : Icons.favorite_border,
                  color: controller.isLiked(post.id) ? Colors.red : TColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '${controller.getLikeCount(post.id)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(width: 20),
          
          // Comment Button - Check if comments are disabled
          GestureDetector(
            onTap: () {
              if (!post.disableComments) {
                _showCommentsDialog(context, controller);
              }
            },
            child: Row(
              children: [
                Icon(
                  post.disableComments ? Icons.chat_bubble_outline : Icons.chat_bubble_outline,
                  color: post.disableComments ? Colors.grey[400] : TColors.primary,
                  size: 20,
                ),
                if (!post.disableComments) ...[
                  const SizedBox(width: 6),
                  Text(
                    '${controller.getCommentCount(post.id)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const Spacer(),
          
          // Share Button
          GestureDetector(
            onTap: () {
              // Add share functionality here
            },
            child: Icon(
              Icons.share_outlined,
              color: TColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.comments.length > 2)
            TextButton(
              onPressed: () => _showCommentsDialog(context, Get.find<ForumController>()),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View all ${post.comments.length} comments',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ),
          
          // Show last 2 comments
          ...post.comments.take(2).map((comment) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${comment.userName} ',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: comment.content,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return DateFormat('MMM d').format(date);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  void _showDeleteDialog(BuildContext context, ForumController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteForumPost(post.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPostDetail(BuildContext context, ForumController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Detail Postingan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Post Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: post.userImageUrl.isNotEmpty
                                ? NetworkImage(post.userImageUrl)
                                : null,
                            child: post.userImageUrl.isEmpty
                                ? Icon(Icons.person, color: Colors.grey[500], size: 20)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  _formatDate(post.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Post Content
                      Text(
                        post.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Location (if exists)
                      if (post.location != null && post.location!.isNotEmpty)
                        _buildLocation(context),
                      
                      const SizedBox(height: 16),
                      
                      // Image (if exists)
                      if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                        _buildImage(context),
                      
                      const SizedBox(height: 20),
                      
                      // Actions
                      _buildActions(context, controller),
                      
                      const SizedBox(height: 20),
                      
                      // Comments Section
                      if (!post.disableComments) ...[
                        const Text(
                          'Komentar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Comments List
                        if (post.comments.isNotEmpty)
                          ...post.comments.map((comment) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: comment.userImageUrl.isNotEmpty
                                      ? NetworkImage(comment.userImageUrl)
                                      : null,
                                  child: comment.userImageUrl.isEmpty
                                      ? Icon(Icons.person, color: Colors.grey[500], size: 16)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.userName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        comment.content,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDate(comment.createdAt),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        
                        // Add Comment Input
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: controller.forumRepository.userController.user.value.profilePicture.isNotEmpty
                                    ? NetworkImage(controller.forumRepository.userController.user.value.profilePicture)
                                    : null,
                                child: controller.forumRepository.userController.user.value.profilePicture.isEmpty
                                    ? Icon(Icons.person, color: Colors.grey[500], size: 16)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,
                                  decoration: InputDecoration(
                                    hintText: 'Tulis komentar...',
                                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: TColors.primary),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Obx(() => IconButton(
                                onPressed: controller.isCommenting.value
                                    ? null
                                    : () => controller.addComment(post.id),
                                icon: controller.isCommenting.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Icon(
                                        Icons.send,
                                        color: TColors.primary,
                                        size: 20,
                                      ),
                              )),
                            ],
                          ),
                        ),
                      ] else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.block, color: Colors.grey[500], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Komentar dinonaktifkan untuk postingan ini',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsDialog(BuildContext context, ForumController controller) {
    // Check if comments are disabled
    if (post.disableComments) {
      Get.snackbar(
        'Komentar Dinonaktifkan',
        'Komentar untuk postingan ini telah dinonaktifkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Comments List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = post.comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: comment.userImageUrl.isNotEmpty
                                ? NetworkImage(comment.userImageUrl)
                                : null,
                            child: comment.userImageUrl.isEmpty
                                ? Icon(Icons.person, color: Colors.grey[600], size: 14)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${comment.userName} ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextSpan(
                                        text: comment.content,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(comment.createdAt),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // Comment Input - Only show if comments are not disabled
              if (!post.disableComments)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: controller.forumRepository.userController.user.value.profilePicture.isNotEmpty
                            ? NetworkImage(controller.forumRepository.userController.user.value.profilePicture)
                            : null,
                        child: controller.forumRepository.userController.user.value.profilePicture.isEmpty
                            ? Icon(Icons.person, color: Colors.grey[600], size: 14)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller.commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: TColors.primary),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() => IconButton(
                        onPressed: controller.isCommenting.value
                            ? null
                            : () => controller.addComment(post.id),
                        icon: controller.isCommenting.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                Icons.send,
                                color: TColors.primary,
                                size: 20,
                              ),
                      )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
