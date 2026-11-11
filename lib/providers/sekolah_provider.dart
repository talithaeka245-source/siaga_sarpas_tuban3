import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class SekolahProvider extends ChangeNotifier {
  String _namaSekolah = 'SMPN 1 Tuban';

  String get namaSekolah => _namaSekolah;

  Future<void> loadNamaSekolah() async {
    try {
      final nama = await DBHelper.instance.getNamaSekolah();
      if (nama != null && nama.trim().isNotEmpty) {
        _namaSekolah = nama;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal mengambil nama sekolah: $e');
    }
  }

  Future<bool> simpanNamaSekolah(String nama) async {
    final namaBaru = nama.trim();

    if (namaBaru.isEmpty) return false;

    try {
      await DBHelper.instance.simpanNamaSekolah(namaBaru);
      _namaSekolah = namaBaru;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Gagal menyimpan nama sekolah: $e');
      return false;
    }
  }
}