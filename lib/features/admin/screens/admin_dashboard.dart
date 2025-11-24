import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/features/admin/controllers/admin_auth_controller.dart';
import 'package:agrigres/features/admin/screens/crud/users_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/forum_posts_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/articles_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/notifications_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/feedback_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/categories_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/banners_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/app_config_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/announcements_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/planting_calendar_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/farms_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/detection_config_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/analyze_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/home_menu_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/guidelines_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/agri_edu_category_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/farm_option_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/planting_calendar_option_management_screen.dart';
import 'package:agrigres/features/admin/screens/crud/level_harga_option_management_screen.dart';
import 'package:agrigres/utils/constraints/sizes.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authController = Get.find<AdminAuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Admin Panel'),
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.grey[50],
              foregroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                Obx(
                  () => authController.currentAdmin.value != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                          child: Center(
                            child: Text(
                              authController.currentAdmin.value!.name,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                IconButton(
                  icon: const Icon(Iconsax.logout),
                  onPressed: () => authController.adminLogout(),
                  tooltip: 'Logout',
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(
                            () => authController.currentAdmin.value != null
                                ? Text(
                                    authController.currentAdmin.value!.name,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          const SizedBox(height: 4),
                          Obx(
                            () => authController.currentAdmin.value != null
                                ? Text(
                                    'Role: ${authController.currentAdmin.value!.role}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),

                    // Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Text(
                        'Manajemen Data',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Users Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.profile_2user,
                      title: 'Manajemen Pengguna',
                      subtitle: 'Kelola data pengguna aplikasi',
                      iconBgColor: Colors.blue[50]!,
                      iconColor: Colors.blue[600]!,
                      onTap: () => Get.to(() => const UsersManagementScreen()),
                    ),

                    // Forum Posts Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.message,
                      title: 'Manajemen Forum',
                      subtitle: 'Kelola postingan forum',
                      iconBgColor: Colors.green[50]!,
                      iconColor: Colors.green[600]!,
                      onTap: () => Get.to(() => const ForumPostsManagementScreen()),
                    ),

                    // Articles Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.document,
                      title: 'Manajemen Artikel',
                      subtitle: 'Kelola artikel dan konten',
                      iconBgColor: Colors.orange[50]!,
                      iconColor: Colors.orange[600]!,
                      onTap: () => Get.to(() => const ArticlesManagementScreen()),
                    ),

                    // Notifications Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.notification,
                      title: 'Manajemen Notifikasi',
                      subtitle: 'Kelola notifikasi dan pengumuman',
                      iconBgColor: Colors.purple[50]!,
                      iconColor: Colors.purple[600]!,
                      onTap: () => Get.to(() => const NotificationsManagementScreen()),
                    ),

                    // Feedback Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.message,
                      title: 'Manajemen Feedback',
                      subtitle: 'Kelola feedback dari pengguna',
                      iconBgColor: Colors.pink[50]!,
                      iconColor: Colors.pink[600]!,
                      onTap: () => Get.to(() => const FeedbackManagementScreen()),
                    ),

                    // Categories Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.category,
                      title: 'Manajemen Kategori',
                      subtitle: 'Kelola kategori penyakit',
                      iconBgColor: Colors.teal[50]!,
                      iconColor: Colors.teal[600]!,
                      onTap: () => Get.to(() => const CategoriesManagementScreen()),
                    ),

                    // Banners Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.image,
                      title: 'Manajemen Banner',
                      subtitle: 'Kelola banner promosi',
                      iconBgColor: Colors.indigo[50]!,
                      iconColor: Colors.indigo[600]!,
                      onTap: () => Get.to(() => const BannersManagementScreen()),
                    ),

                    // App Config Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.setting,
                      title: 'Konfigurasi Aplikasi',
                      subtitle: 'Kelola API keys dan konfigurasi',
                      iconBgColor: Colors.cyan[50]!,
                      iconColor: Colors.cyan[600]!,
                      onTap: () => Get.to(() => const AppConfigManagementScreen()),
                    ),

                    // Announcements Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.notification,
                      title: 'Manajemen Pengumuman',
                      subtitle: 'Kelola pengumuman dan pembaruan fitur',
                      iconBgColor: Colors.amber[50]!,
                      iconColor: Colors.amber[600]!,
                      onTap: () => Get.to(() => const AnnouncementsManagementScreen()),
                    ),

                    // Planting Calendar Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.calendar,
                      title: 'Manajemen Kalender Tanam',
                      subtitle: 'Kelola kalender tanam dan waktu optimal',
                      iconBgColor: Colors.teal[50]!,
                      iconColor: Colors.teal[600]!,
                      onTap: () => Get.to(() => const PlantingCalendarManagementScreen()),
                    ),

                    // Farms Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.home_2,
                      title: 'Manajemen Lahan',
                      subtitle: 'Kelola data lahan pengguna',
                      iconBgColor: Colors.brown[50]!,
                      iconColor: Colors.brown[600]!,
                      onTap: () => Get.to(() => const FarmsManagementScreen()),
                    ),

                    // Detection Config Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.scan_barcode,
                      title: 'Konfigurasi Deteksi',
                      subtitle: 'Kelola daftar penyakit dan keyword Gemini',
                      iconBgColor: Colors.lime[50]!,
                      iconColor: Colors.lime[700]!,
                      onTap: () => Get.to(() => const DetectionConfigManagementScreen()),
                    ),

                    // Analyze Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.document_text,
                      title: 'Manajemen Data Analisis',
                      subtitle: 'Kelola data hasil analisis penyakit tanaman',
                      iconBgColor: Colors.purple[50]!,
                      iconColor: Colors.purple[600]!,
                      onTap: () => Get.to(() => const AnalyzeManagementScreen()),
                    ),

                    // Home Menu Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.menu,
                      title: 'Manajemen Menu Utama',
                      subtitle: 'Kelola menu utama aplikasi',
                      iconBgColor: Colors.blue[50]!,
                      iconColor: Colors.blue[600]!,
                      onTap: () => Get.to(() => const HomeMenuManagementScreen()),
                    ),

                    // Guidelines Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.document_text,
                      title: 'Manajemen Panduan',
                      subtitle: 'Kelola panduan penggunaan aplikasi',
                      iconBgColor: Colors.green[50]!,
                      iconColor: Colors.green[600]!,
                      onTap: () => Get.to(() => const GuidelinesManagementScreen()),
                    ),

                    // AgriEdu Category Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.category,
                      title: 'Manajemen Kategori AgriEdu',
                      subtitle: 'Kelola kategori video AgriEdu',
                      iconBgColor: Colors.orange[50]!,
                      iconColor: Colors.orange[600]!,
                      onTap: () => Get.to(() => const AgriEduCategoryManagementScreen()),
                    ),

                    // Farm Option Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.home_2,
                      title: 'Manajemen Opsi Lahan',
                      subtitle: 'Kelola jenis tanaman dan status lahan',
                      iconBgColor: Colors.brown[50]!,
                      iconColor: Colors.brown[600]!,
                      onTap: () => Get.to(() => const FarmOptionManagementScreen()),
                    ),

                    // Planting Calendar Option Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.calendar,
                      title: 'Manajemen Opsi Kalender Tanam',
                      subtitle: 'Kelola jenis tanaman untuk kalender tanam',
                      iconBgColor: Colors.teal[50]!,
                      iconColor: Colors.teal[600]!,
                      onTap: () => Get.to(() => const PlantingCalendarOptionManagementScreen()),
                    ),

                    // Level Harga Option Management
                    _buildManagementCard(
                      context,
                      icon: Iconsax.dollar_circle,
                      title: 'Manajemen Level Harga',
                      subtitle: 'Kelola level harga untuk AgriInfo',
                      iconBgColor: Colors.blue[50]!,
                      iconColor: Colors.blue[600]!,
                      onTap: () => Get.to(() => const LevelHargaOptionManagementScreen()),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
            ),

            const SizedBox(width: 10),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Iconsax.arrow_right_3,
              color: Colors.grey[400],
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

