import 'dart:io';

import 'package:get/get.dart';
import 'package:agrigres/features/detection/models/result_analyze_model.dart';
import '../../../data/repositories/disease/model_repository.dart';
import '../../../utils/constraints/image_strings.dart';
import '../../../utils/helpers/loaders.dart';
import '../../../utils/logging/logger.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../screens/media/result_analyze/detection_failed_analyze.dart';
import '../screens/media/result_analyze/result_analyze.dart';

class ModelController extends GetxController {
  final  modelRepository = Get.put(ModelRepository());
  final resultAnalyzeModel = <ResultAnalyzeModel>[].obs;
  final  isModelLoaded = false.obs;
  final  selectedLabel = ''.obs;
  final handlingInstructions = <String, Map<String, String>>{}.obs;
  final selectedModel =''.obs;

  @override
  void onInit() {
    super.onInit();
    resultAnalyzeModel.assignAll(modelRepository.getDetectionResults());
  }

  Future<void> loadModel() async {
    try {
      if (selectedModel.value.isEmpty) {
        TLoaders.errorSnackBar(title: 'Oh tidak...', message: 'Silakan pilih jenis tanaman terlebih dahulu.');
        return; // Berhenti eksekusi jika model belum dipilih
      }
      TLoggerHelper.info("Attempting to load model...");
      String? res = await modelRepository.loadModel(selectedModel.value!);
      if (res != null) {
        TLoggerHelper.info("Model loaded successfully: $res");
        isModelLoaded.value = true;
      } else {
        TLoggerHelper.error("Failed to load model");
        throw "Could not load model.";
      }
    } catch (e) {
      TLoggerHelper.error("Error loading model", e);
      throw "Could not load model: ${e.toString()}";
    }
  }

  Future<void> fetchResultAnalyzeDisease(String label, double confidence) async {
    try {
      TFullScreenLoader.openLoadingDialog('Sedang Analisis...', TImages.docerAnimation);

      isModelLoaded.value = true;
      selectedLabel.value = label;

      final resultAnalyze = await modelRepository.getResultAnalyzeDisease(label);
      resultAnalyzeModel.assignAll(resultAnalyze);

      if (resultAnalyze.isNotEmpty) {
        final result = resultAnalyze.first;
        handlingInstructions[label] = {
          'pencegahan': result.pencegahan,
          'pengendalian_hayati': result.pengendalianHayati,
          'pengendalian_kimiawi': result.pengendalianKimiawi,
          'penyebab': result.penyebab,
          'gejala': result.gejala,
          'kategori': result.kategori,
          'label': result.label,
          'probability': result.probability,
        };
        resultAnalyzeModel.first.probability = (confidence * 100).toStringAsFixed(1) + '%';

      }
      await Future.delayed(Duration(seconds: 5));

    } catch (e) {
      TLoggerHelper.error('Error while fetching result analyze', e);
      TLoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    } finally {
      isModelLoaded.value = false;
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> runInference(String imagePath, {required bool isFromCamera}) async {
    try {
      if (selectedModel.value.isEmpty) {
        throw "Silakan pilih tanaman terlebih dahulu.";
      }
      TFullScreenLoader.openLoadingDialog('Sedang Menganalisis...', TImages.docerAnimation);

      List<dynamic>? recognitionsResult;

      if (isFromCamera) {
        recognitionsResult = await modelRepository.runGeminiInference(imagePath);
      } else {
        recognitionsResult = await modelRepository.runModelOnImage(imagePath);
        // recognitionsResult = await modelRepository.runGeminiInference(imagePath);
      }

      if (recognitionsResult != null) {
        String label = recognitionsResult.first['label'];
        double confidence = recognitionsResult.first['confidence'];
        String confidencePercentage = (confidence * 100).toStringAsFixed(1) + '%';

        if (confidence < 0.7 || label == "Bukan Tanaman") {
          await Future.delayed(Duration(seconds: 3));
          TFullScreenLoader.stopLoading();

          Get.to(() => const DetectionFailedScreen());
        } else {
          await fetchResultAnalyzeDisease(label, confidence);

          Get.to(() => ResultScreen(
            label: label,
            confidence: confidencePercentage,
            resultAnalyzeModel: resultAnalyzeModel.first,
            imagePath: imagePath,
          ));
        }
      }
    } catch (e) {
      TLoggerHelper.error("Error running inference", e);
    }
  }

  Future<void> releaseModel() async {
    try {
      await modelRepository.closeModel();
      isModelLoaded.value = false;
    } catch (e) {
      TLoggerHelper.error("Error releasing model", e);
    }
  }

  List<ResultAnalyzeModel> getDetectionResults() {
    return modelRepository.getDetectionResults();
  }

  Future<void> saveCurrentResult(String imagePath) async {
    try {
      final resultAnalyze = resultAnalyzeModel.first;
      final String savedImagePath = await modelRepository.saveImageLocally(File(imagePath));
      final result = ResultAnalyzeModel(
        label: resultAnalyze.label,
        pencegahan: resultAnalyze.pencegahan,
        pengendalianHayati: resultAnalyze.pengendalianHayati,
        pengendalianKimiawi: resultAnalyze.pengendalianKimiawi,
        penyebab: resultAnalyze.penyebab,
        gejala: resultAnalyze.gejala,
        kategori: resultAnalyze.kategori,
        imagePath: savedImagePath,
        probability: resultAnalyze.probability,
      );
      modelRepository.saveDetectionResult(result);
      resultAnalyzeModel.add(result);
      TLoaders.successSnackBar(title: 'Selamat!', message: "Hasil analisis berhasil disimpan");
    } catch (e) {
      TLoggerHelper.error("Error saving result", e);
      TLoaders.errorSnackBar(title: 'Selamat!', message: "Hasil analisis gagal disimpan");

    }
  }

  void deleteResultByIndex(int index) {
    try {
      modelRepository.deleteDetectionResultByIndex(index);
      resultAnalyzeModel.removeAt(index);
      TLoaders.successSnackBar(title: 'Selamat!', message: 'Hasil analisis berhasil dihapus!');
    } catch (e) {
      TLoggerHelper.error("Error deleting result", e);
      TLoaders.errorSnackBar(title: 'Oh tidak...', message: "Gagal menghapus hasil deteksi");
    }
  }

  void deleteAllResults() {
    try {
      modelRepository.deleteAllDetectionResults();
      resultAnalyzeModel.clear();
      TLoaders.successSnackBar(title: 'Selamat!', message: "Semua hasil analisis berhasil dihapus!");
    } catch (e) {
      TLoggerHelper.error("Error deleting all results", e);
      TLoaders.errorSnackBar(title: 'Oh tidak...', message: "Gagal menghapus semua hasil analisis");
    }
  }

}