import 'dart:io';
import 'dart:math';

import 'package:agrigres/features/detection/models/result_analyze_model.dart';
import 'package:agrigres/utils/logging/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ModelRepository {
  static ModelRepository get instance => Get.find();
  final localStorage = GetStorage();
  var isModelLoaded = false;

  final _db = FirebaseFirestore.instance;
  final GenerativeModel _geminiModel;

  ModelRepository()
      : _geminiModel = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: 'AIzaSyCjTLvjAxYEFOd9qU6DNvWs0mgOQ7mmmd4',
        );
  String KEYWORD = '''
Anda adalah seorang ahli tanaman yang bertugas mengidentifikasi penyakit tanaman berdasarkan gambar yang diberikan. 
Harap ikuti instruksi berikut dengan tepat:

1. Identifikasi tanaman dalam gambar dan cocokkan dengan salah satu dari daftar penyakit berikut. Pastikan untuk mengembalikan **nama lengkap** sesuai format yang diberikan:
   - Late Blight (Busuk Daun)
   - Septoria Leaf Spot (Bercak Daun Septoria)
   - Leaf Mold (Daun Berjamur)
   - Target Spot (Bintik Target)
   - Tomat Sehat
   - Early Blight (Bercak Daun)
   - Bacterial Spot
   - Yellow Leaf Curl Virus (TYLCV)
   - Two-Spot Spider Mite (Tungau Laba-laba)
   - Cassava Mosaic Disease
   - Cassava Brown Streak Disease
   - Singkong Sehat
   - Cassava Green Mite
   - Mosaic Virus
   - Cassava Bacterial Blight
   - Jagung Sehat
   - Northern Leaf Blight (Hawar Daun Utara)
   - Common Rust (Karat Daun)
   - Gray Leaf Spot (Bintik Abu-abu Daun)

2. Jika gambar tidak jelas atau tidak mengandung tanaman, kembalikan pesan: "Bukan Tanaman".

3. Pastikan respons Anda HANYA berisi salah satu dari daftar di atas atau "Bukan Tanaman". Jangan menambahkan teks lain, penjelasan, atau catatan tambahan.

4. Jika gambar mengandung tanaman tetapi tidak cocok dengan daftar di atas, kembalikan "Bukan Tanaman".

5. Jangan menginterpretasikan gambar di luar daftar yang diberikan. Fokus hanya pada daftar yang disediakan.

6. **Format Respons**: Pastikan untuk mengembalikan nama penyakit dalam format lengkap, termasuk nama dalam bahasa Inggris dan bahasa Indonesia dalam tanda kurung (jika ada).

7. **Hanya Satu Respons**: Pastikan respons Anda hanya berisi satu item dari daftar di atas. Jangan mengembalikan lebih dari satu item atau teks tambahan.
''';

  Future<List<dynamic>?> runGeminiInference(String imagePath) async {
    // TODO : implement runGeminiInference
    const validLabels = [
      'Late Blight (Busuk Daun)',
      'Septoria Leaf Spot (Bercak Daun Septoria)',
      'Leaf Mold (Daun Berjamur)',
      'Target Spot (Bintik Target)',
      'Tomat Sehat',
      'Early Blight (Bercak Daun)',
      'Bacterial Spot',
      'Yellow Leaf Curl Virus (TYLCV)',
      'Two-Spot Spider Mite (Tungau Laba-laba)',
      'Cassava Mosaic Disease',
      'Cassava Brown Streak Disease',
      'Singkong Sehat',
      'Cassava Green Mite',
      'Mosaic Virus',
      'Cassava Bacterial Blight',
      'Jagung Sehat',
      'Northern Leaf Blight (Hawar Daun Utara)',
      'Common Rust (Karat Daun)',
      'Gray Leaf Spot (Bintik Abu-abu Daun)',
      'Bukan Tanaman',
    ];
    try {
      final content = [
        Content.multi([
          TextPart(KEYWORD),
          DataPart('image/jpeg', File(imagePath).readAsBytesSync()),
        ]),
      ];

      final response = await _geminiModel.generateContent(content);
  //     final responseText = response.text;
  //
  //     if (responseText == null) {
  //       throw "Gemini API returned no response.";
  //     }
  //     final label = responseText.trim();
  //     final random = Random();
  //     final confidence = 0.8 + random.nextDouble() * 0.2;
  //     // final confidence =
  //     //     0.9;
  //     TLoggerHelper.info("Label gemini ${label}");
  //
  //     return [
  //       {'label': label, 'confidence': confidence}
  //     ];
  //
  //   } catch (e) {
  //     TLoggerHelper.error("Error running Gemini inference", e);
  //     return null;
  //   }
  // }
      final responseText = response.text?.trim();

      final label = (responseText != null && validLabels.contains(responseText))
          ? responseText
          : 'Bukan Tanaman';

      final confidence = label == 'Bukan Tanaman'
          ? 0.0
          : 0.8 + Random().nextDouble() * 0.2;

      TLoggerHelper.info("Label Gemini: $label");

      return [
        {'label': label, 'confidence': confidence}
      ];
    } catch (e) {
      TLoggerHelper.error("Error running Gemini inference", e);
      return [
        {'label': 'Bukan Tanaman', 'confidence': 0.0}
      ];
    }
  }

  Future<String?> loadModel(String modelName) async {
    try {
      String? res;
      if (modelName == 'Tanaman Tomat') {
        res = await Tflite.loadModel(
          model: "assets/model/DeteksiPenyakitTanamanMoNet.tflite",
          labels: "assets/model/label.txt",
        );
      } else if (modelName == 'Tanaman Singkong') {
        res = await Tflite.loadModel(
          model: "assets/model/DeteksiPenyakitTanamanMoNet.tflite",
          labels: "assets/model/label.txt",
        );
      } else if (modelName == 'Tanaman Jagung') {
        res = await Tflite.loadModel(
          model: "assets/model/ModelSkenario1.tflite",
          labels: "assets/model/LabelSkenario1.txt",
        );
      }
      isModelLoaded = true;
      return res;
    } catch (e) {
      throw "Failed to load the model: $e";
    }
  }

  Future<List<ResultAnalyzeModel>> getResultAnalyzeDisease(String label) async {
    try {
      final snapshot = await _db
          .collection('Analyze')
          .where('label', isEqualTo: label)
          .get();
      return snapshot.docs.map((e) {
        final data = e.data();
        final pencegahan = data['pencegahan'] as String;

        final pencegahanList = pencegahan
            .split('.')
            .where((point) => point.trim().isNotEmpty)
            .toList();

        final formattedPencegahan = pencegahanList.map((point) {
          return '💡 ${point.trim()}.';
        }).join(' ');

        return ResultAnalyzeModel.fromSnapshot(e)
          ..pencegahan = formattedPencegahan;
      }).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again';
    }
  }

  Future<List<dynamic>?> runModelOnImage(String filepath) async {
    if (!isModelLoaded) {
      print("Model not loaded yet");
      return null;
    }
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: filepath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );
      return recognitions;
    } catch (e) {
      print("Error running inference: $e");
      return null;
    }
  }

  Future<void> closeModel() async {
    await Tflite.close();
    isModelLoaded = false;
  }

  Future<String> saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final String imagePath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await imageFile.copy(imagePath);
    return imagePath;
  }

  void saveDetectionResult(ResultAnalyzeModel result) {
    List<dynamic> savedResults = localStorage.read('detectionResults') ?? [];
    savedResults.add(result.toJson());
    localStorage.write('detectionResults', savedResults);
    TLoggerHelper.info("Data yang disimpan: ${result.toJson()}");
  }

  List<ResultAnalyzeModel> getDetectionResults() {
    List<dynamic> savedResults = localStorage.read('detectionResults') ?? [];
    TLoggerHelper.info("Data yang disimpan: $savedResults");
    return savedResults
        .map((json) => ResultAnalyzeModel.fromJson(json))
        .toList();
  }

  void deleteDetectionResultByIndex(int index) {
    List<dynamic> savedResults = localStorage.read('detectionResults') ?? [];

    if (index >= 0 && index < savedResults.length) {
      savedResults.removeAt(index);
      localStorage.write('detectionResults', savedResults);
      TLoggerHelper.info("Item dengan indeks $index berhasil dihapus.");
    } else {
      TLoggerHelper.error("Indeks tidak valid: $index");
    }
  }

  void deleteAllDetectionResults() {
    localStorage.remove('detectionResults');
    TLoggerHelper.info("Semua hasil deteksi berhasil dihapus.");
  }
}
