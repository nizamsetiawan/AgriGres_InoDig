import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/guideline_model.dart';
import 'package:agrigres/utils/logging/logger.dart';

class GuidelinesController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final guidelines = <GuidelineModel>[].obs;
  final isLoading = false.obs;
  final String? headerTitle; // Optional header title

  GuidelinesController({this.headerTitle});

  @override
  void onInit() {
    super.onInit();
    loadGuidelines();
  }

  /// Load all guidelines from Firebase
  Future<void> loadGuidelines() async {
    try {
      isLoading.value = true;
      TLoggerHelper.info('Loading guidelines from Firebase...');

      final snapshot = await _db
          .collection('Guidelines')
          .where('is_active', isEqualTo: true)
          .orderBy('order')
          .get();

      final loadedGuidelines = snapshot.docs
          .map((doc) => GuidelineModel.fromSnapshot(doc))
          .where((guideline) => guideline.title.isNotEmpty && guideline.description.isNotEmpty)
          .toList();

      guidelines.assignAll(loadedGuidelines);
      TLoggerHelper.info('Loaded ${guidelines.length} guidelines from Firebase');

      // If no guidelines found, use default
      if (guidelines.isEmpty) {
        _loadDefaultGuidelines();
      }
    } catch (e) {
      TLoggerHelper.error('Error loading guidelines from Firebase', e);
      // Fallback to default guidelines
      _loadDefaultGuidelines();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load default guidelines (fallback)
  void _loadDefaultGuidelines() {
    TLoggerHelper.info('Using default guidelines');
    guidelines.assignAll([
      GuidelineModel(
        id: 'step1',
        title: 'Langkah 1: Ambil Gambar Daun',
        description: 'Ambil gambar daun tanaman yang ingin Anda deteksi menggunakan kamera ponsel pintar. '
            'Pastikan gambar yang diambil jelas dan fokus pada daun yang ingin diperiksa.',
        icon: '1',
        order: 1,
        isActive: true,
      ),
      GuidelineModel(
        id: 'step2',
        title: 'Langkah 2: Deteksi Penyakit Tanaman',
        description: 'Aplikasi ini mendeteksi penyakit pada daun tanaman dengan menggunakan algoritma kecerdasan buatan. '
            'Namun, perlu diketahui bahwa aplikasi ini hanya mendukung deteksi penyakit pada tiga jenis tanaman: Tomat, Singkong, dan Jagung.',
        icon: '2',
        order: 2,
        isActive: true,
      ),
      GuidelineModel(
        id: 'step3',
        title: 'Langkah 3: Analisis Penyakit',
        description: 'Aplikasi akan menganalisis gambar dan memberikan informasi tentang kemungkinan penyakit pada daun tanaman. '
            'Anda akan menerima rekomendasi pengobatan untuk penyakit tersebut.',
        icon: '3',
        order: 3,
        isActive: true,
      ),
      GuidelineModel(
        id: 'step4',
        title: 'Langkah 4: Lakukan Tindakan Pencegahan',
        description: 'Ikuti rekomendasi untuk menangani penyakit tersebut. Anda dapat menggunakan pestisida yang sesuai atau metode perawatan lainnya untuk mencegah penyebaran penyakit.',
        icon: '4',
        order: 4,
        isActive: true,
      ),
      GuidelineModel(
        id: 'step5',
        title: 'Langkah 5: Pantau Kesehatan Tanaman',
        description: 'Setelah perawatan dilakukan, terus pantau kondisi tanaman Anda menggunakan aplikasi untuk memastikan tanaman tetap sehat dan bebas dari penyakit.',
        icon: '5',
        order: 5,
        isActive: true,
      ),
      GuidelineModel(
        id: 'feature_history',
        title: 'Fitur Tambahan: Riwayat Analisis',
        description: 'agrigres menyediakan fitur riwayat analisis yang memungkinkan Anda untuk melacak hasil deteksi penyakit tanaman sebelumnya. '
            'Fitur ini membantu Anda untuk mengawasi perkembangan tanaman Anda dari waktu ke waktu dan memastikan tanaman Anda selalu terjaga dari penyakit.',
        icon: 'ℹ️',
        order: 6,
        isActive: true,
      ),
      GuidelineModel(
        id: 'feature_article',
        title: 'Fitur Tambahan: Artikel Pertanian',
        description: 'Aplikasi ini juga menyediakan berbagai artikel yang berhubungan dengan pertanian, khususnya yang berkaitan dengan tiga jenis tanaman utama kami, yaitu Tomat, Singkong, dan Jagung. '
            'Artikel-artikel ini memberikan informasi yang berguna mengenai perawatan tanaman, cara mengatasi penyakit, dan tips bertani yang lebih efektif.',
        icon: '📚',
        order: 7,
        isActive: true,
      ),
    ]);
  }
}

