
class LaporanModel {
  final int? id;
  final String reporter;
  final String school;
  final String kategori;
  final String namaFasilitas;
  final String lokasi;
  final String deskripsi;
  final String tingkatKerusakan;
  final String status;
  final String? foto;
  final String tanggal;
  final String catatan;

  LaporanModel({
    this.id,
    required this.reporter,
    required this.school,
    required this.kategori,
    required this.namaFasilitas,
    required this.lokasi,
    required this.deskripsi,
    required this.tingkatKerusakan,
    this.status = 'Baru',
    this.foto,
    required this.tanggal,
    this.catatan = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporter': reporter,
      'school': school,
      'kategori': kategori,
      'namaFasilitas': namaFasilitas,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'tingkatKerusakan': tingkatKerusakan,
      'status': status,
      'foto': foto,
      'tanggal': tanggal,
      'catatan': catatan,
    };
  }

  factory LaporanModel.fromMap(Map<String, dynamic> map) {
    return LaporanModel(
      id: map['id'] as int?,
      reporter: map['reporter'] ?? '',
      school: map['school'] ?? '',
      kategori: map['kategori'] ?? '',
      namaFasilitas: map['namaFasilitas'] ?? '',
      lokasi: map['lokasi'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      tingkatKerusakan: map['tingkatKerusakan'] ?? '',
      status: map['status'] ?? 'Baru',
      foto: map['foto'],
      tanggal: map['tanggal'] ?? '',
      catatan: map['catatan'] ?? '',
    );
  }

  LaporanModel copyWith({
    int? id,
    String? status,
    String? catatan,
  }) {
    return LaporanModel(
      id: id ?? this.id,
      reporter: reporter,
      school: school,
      kategori: kategori,
      namaFasilitas: namaFasilitas,
      lokasi: lokasi,
      deskripsi: deskripsi,
      tingkatKerusakan: tingkatKerusakan,
      status: status ?? this.status,
      foto: foto,
      tanggal: tanggal,
      catatan: catatan ?? this.catatan,
    );
  }
}

// Model untuk menyimpan riwayat perubahan status.
class RiwayatStatusModel {
  final int? id;
  final int laporanId;
  final String status;
  final String judul;
  final String catatan;
  final DateTime waktu;

  RiwayatStatusModel({
    this.id,
    required this.laporanId,
    required this.status,
    required this.judul,
    this.catatan = '',
    required this.waktu,
  });

  factory RiwayatStatusModel.fromMap(Map<String, dynamic> map) {
    return RiwayatStatusModel(
      id: map['id'] as int?,
      laporanId: map['laporanId'] as int,
      status: map['status'] ?? '',
      judul: map['judul'] ?? '',
      catatan: map['catatan'] ?? '',
      waktu: DateTime.tryParse(map['waktu'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'laporanId': laporanId,
      'status': status,
      'judul': judul,
      'catatan': catatan,
      'waktu': waktu.toIso8601String(),
    };
  }
}
