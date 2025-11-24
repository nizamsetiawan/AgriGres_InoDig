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
  final  selectedLabel = ''.obs;
  final handlingInstructions = <String, Map<String, String>>{}.obs;
  final selectedModel =''.obs;
  final availablePlantTypes = <String>[].obs;
  bool _isAnalysisCancelled = false;

  @override
  void onInit() {
    super.onInit();
    resultAnalyzeModel.assignAll(modelRepository.getDetectionResults());
    loadPlantTypes();
  }

  /// Load available plant types from Firebase
  Future<void> loadPlantTypes() async {
    try {
      final plantTypes = await modelRepository.getAvailablePlantTypes();
      availablePlantTypes.assignAll(plantTypes);
      TLoggerHelper.info("Loaded ${plantTypes.length} plant types");
    } catch (e) {
      TLoggerHelper.error("Error loading plant types", e);
      // Fallback to default
      availablePlantTypes.assignAll(['Tanaman Tomat', 'Tanaman Singkong', 'Tanaman Jagung']);
    }
  }

  Future<void> fetchResultAnalyzeDisease(String label, double confidence) async {
    try {
      // Check if cancelled before starting
      if (_isAnalysisCancelled) {
        return;
      }

      TFullScreenLoader.openLoadingDialog('Sedang Analisis...', TImages.docerAnimation);

      selectedLabel.value = label;

      // Check if cancelled before API call
      if (_isAnalysisCancelled) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final resultAnalyze = await modelRepository.getResultAnalyzeDisease(label);
      
      // Check if cancelled after API call
      if (_isAnalysisCancelled) {
        TFullScreenLoader.stopLoading();
        return;
      }

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
      
      // Check if cancelled before delay
      if (_isAnalysisCancelled) {
        TFullScreenLoader.stopLoading();
        return;
      }
      
      await Future.delayed(Duration(seconds: 5));

    } catch (e) {
      if (!_isAnalysisCancelled) {
        TLoggerHelper.error('Error while fetching result analyze', e);
        TLoaders.errorSnackBar(title: 'Kesalahan', message: e.toString());
      }
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> runInference(String imagePath, {required bool isFromCamera}) async {
    try {
      // Reset cancellation flag
      _isAnalysisCancelled = false;

      if (selectedModel.value.isEmpty) {
        throw "Silakan pilih tanaman terlebih dahulu.";
      }
      
      // Check if cancelled before starting
      if (_isAnalysisCancelled) {
        return;
      }

      TFullScreenLoader.openLoadingDialog('Sedang Menganalisis...', TImages.docerAnimation);

      // Always use Gemini API for both camera and gallery images
      // Pass selectedModel to filter results based on plant type
      List<dynamic>? recognitionsResult = await modelRepository.runGeminiInference(
        imagePath,
        selectedModel: selectedModel.value,
      );

      // Check if cancelled after inference
      if (_isAnalysisCancelled) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (recognitionsResult != null) {
        String label = recognitionsResult.first['label'];
        double confidence = recognitionsResult.first['confidence'];
        String confidencePercentage = (confidence * 100).toStringAsFixed(1) + '%';

        if (confidence < 0.7 || label == "Bukan Tanaman") {
          if (_isAnalysisCancelled) {
            TFullScreenLoader.stopLoading();
            return;
          }
          await Future.delayed(Duration(seconds: 3));
          
          if (_isAnalysisCancelled) {
            TFullScreenLoader.stopLoading();
            return;
          }
          
          TFullScreenLoader.stopLoading();

          Get.to(() => const DetectionFailedScreen());
        } else {
          await fetchResultAnalyzeDisease(label, confidence);

          // Check if cancelled before navigation
          if (_isAnalysisCancelled) {
            return;
          }

          Get.to(() => ResultScreen(
            label: label,
            confidence: confidencePercentage,
            resultAnalyzeModel: resultAnalyzeModel.first,
            imagePath: imagePath,
          ));
        }
      }
    } catch (e) {
      if (!_isAnalysisCancelled) {
        TLoggerHelper.error("Error running inference", e);
        TFullScreenLoader.stopLoading();
      }
    }
  }

  /// Cancel ongoing analysis process
  void cancelAnalysis() {
    _isAnalysisCancelled = true;
    TLoggerHelper.info("Analysis cancelled by user");
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
      TLoaders.errorSnackBar(title: 'Kesalahan', message: "Hasil analisis gagal disimpan");

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