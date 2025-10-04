class NotificationModel {
  final String id;
  final String jenisDarurat;
  final String lokasiLahan;
  final String kontakPetani;
  final String namaPelapor;
  final DateTime tanggalTerjadi;
  final String deskripsiSingkat;
  final List<String> imageUrls;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    required this.id,
    required this.jenisDarurat,
    required this.lokasiLahan,
    required this.kontakPetani,
    required this.namaPelapor,
    required this.tanggalTerjadi,
    required this.deskripsiSingkat,
    required this.imageUrls,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      jenisDarurat: json['jenis_darurat'] ?? '',
      lokasiLahan: json['lokasi_lahan'] ?? '',
      kontakPetani: json['kontak_petani'] ?? '',
      namaPelapor: json['nama_pelapor'] ?? '',
      tanggalTerjadi: DateTime.parse(json['tanggal_terjadi']),
      deskripsiSingkat: json['deskripsi_singkat'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jenis_darurat': jenisDarurat,
      'lokasi_lahan': lokasiLahan,
      'kontak_petani': kontakPetani,
      'nama_pelapor': namaPelapor,
      'tanggal_terjadi': tanggalTerjadi.toIso8601String(),
      'deskripsi_singkat': deskripsiSingkat,
      'image_urls': imageUrls,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? jenisDarurat,
    String? lokasiLahan,
    String? kontakPetani,
    String? namaPelapor,
    DateTime? tanggalTerjadi,
    String? deskripsiSingkat,
    List<String>? imageUrls,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      jenisDarurat: jenisDarurat ?? this.jenisDarurat,
      lokasiLahan: lokasiLahan ?? this.lokasiLahan,
      kontakPetani: kontakPetani ?? this.kontakPetani,
      namaPelapor: namaPelapor ?? this.namaPelapor,
      tanggalTerjadi: tanggalTerjadi ?? this.tanggalTerjadi,
      deskripsiSingkat: deskripsiSingkat ?? this.deskripsiSingkat,
      imageUrls: imageUrls ?? this.imageUrls,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NotificationFormData {
  String jenisDarurat;
  String lokasiLahan;
  String kontakPetani;
  DateTime tanggalTerjadi;
  String deskripsiSingkat;
  List<String> imagePaths;

  NotificationFormData({
    this.jenisDarurat = '',
    this.lokasiLahan = '',
    this.kontakPetani = '',
    DateTime? tanggalTerjadi,
    this.deskripsiSingkat = '',
    this.imagePaths = const [],
  }) : tanggalTerjadi = tanggalTerjadi ?? DateTime.now();

  bool get isValid {
    return jenisDarurat.isNotEmpty &&
        lokasiLahan.isNotEmpty &&
        deskripsiSingkat.isNotEmpty;
  }
}

