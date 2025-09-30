import 'package:cloud_firestore/cloud_firestore.dart';

class ResultAnalyzeModel {
  String gejala;
  String kategori;
  String label;
  String pencegahan;
  String pengendalianHayati;
  String pengendalianKimiawi;
  String penyebab;
  String imagePath;
  String probability;

  ResultAnalyzeModel({
    required this.gejala,
    required this.kategori,
    required this.label,
    required this.pencegahan,
    required this.pengendalianHayati,
    required this.pengendalianKimiawi,
    required this.penyebab,
    required this.imagePath,
    required this.probability

  });

  static ResultAnalyzeModel empty() => ResultAnalyzeModel(
    gejala: '',
    kategori: '',
    label: '',
    pencegahan: '',
    pengendalianHayati: '',
    pengendalianKimiawi: '',
    penyebab: '',
    imagePath: '',
    probability: ''
  );

  Map<String, dynamic> toJson() {
    return {
      'gejala': gejala,
      'kategori': kategori,
      'label': label,
      'pencegahan': pencegahan,
      'pengendalian_hayati': pengendalianHayati,
      'pengendalian_kimiawi': pengendalianKimiawi,
      'penyebab': penyebab,
      'imagePath': imagePath,
      'probability': probability
    };
  }

  factory ResultAnalyzeModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return ResultAnalyzeModel.empty();
    return ResultAnalyzeModel(
      gejala: data['gejala'] ?? '',
      kategori: data['kategori'] ?? '',
      label: data['label'] ?? '',
      pencegahan: data['pencegahan'] ?? '',
      pengendalianHayati: data['pengendalian_hayati'] ?? '',
      pengendalianKimiawi: data['pengendalian_kimiawi'] ?? '',
      penyebab: data['penyebab'] ?? '',
      imagePath: data['imagePath'] ?? '',
      probability: data['probability'] ?? ''
    );
  }

  factory ResultAnalyzeModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() != null) {
      final data = snapshot.data()!;
      return ResultAnalyzeModel(
        gejala: data['gejala'] ?? '',
        kategori: data['kategori'] ?? '',
        label: data['label'] ?? '',
        pencegahan: data['pencegahan'] ?? '',
        pengendalianHayati: data['pengendalian_hayati'] ?? '',
        pengendalianKimiawi: data['pengendalian_kimiawi'] ?? '',
        penyebab: data['penyebab'] ?? '',
        imagePath: data['imagePath'] ?? '',
        probability: data['probability'] ?? ''
      );
    } else {
      return ResultAnalyzeModel.empty();
    }
  }

  factory ResultAnalyzeModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ResultAnalyzeModel(
      gejala: data['gejala'] ?? '',
      kategori: data['kategori'] ?? '',
      label: data['label'] ?? '',
      pencegahan: data['pencegahan'] ?? '',
      pengendalianHayati: data['pengendalian_hayati'] ?? '',
      pengendalianKimiawi: data['pengendalian_kimiawi'] ?? '',
      penyebab: data['penyebab'] ?? '',
      imagePath: data['imagePath'] ?? '',
      probability: data['probability'] ?? ''
    );
  }
}