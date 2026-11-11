
import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/laporan_model.dart';

class LaporanProvider extends ChangeNotifier {
  List<LaporanModel> _laporan = [];
  bool _isLoading = false;

  List<LaporanModel> get laporan => List.unmodifiable(_laporan);

  bool get isLoading => _isLoading;

  int get totalLaporan => _laporan.length;

  int get laporanBaru => _jumlahStatus('Baru');

  int get laporanDiproses => _jumlahStatus('Diproses');

  int get laporanSelesai => _jumlahStatus('Selesai');

  int get laporanDitolak => _jumlahStatus('Ditolak');

  int _jumlahStatus(String status) {
    return _laporan.where((item) {
      return item.status.trim().toLowerCase() ==
          status.toLowerCase();
    }).length;
  }

  // MEMUAT LAPORAN
  Future<void> loadLaporan() async {
    _isLoading = true;
    notifyListeners();

    try {
      _laporan = await DBHelper.instance.getAllLaporan();
    } catch (e) {
      debugPrint('Gagal mengambil laporan: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // LAPORAN MILIK PENGGUNA
  List<LaporanModel> laporanPengguna(String username) {
    return _laporan
        .where((item) => item.reporter == username)
        .toList();
  }

  // MENAMBAH LAPORAN
  Future<bool> tambahLaporan(LaporanModel data) async {
    try {
      final id = await DBHelper.instance.insertLaporan(data);

      if (id <= 0) {
        throw Exception('Data laporan tidak berhasil disimpan.');
      }

      await loadLaporan();

      return true;
    } catch (e, stackTrace) {
      debugPrint('GAGAL MENAMBAH LAPORAN: $e');
      debugPrint('$stackTrace');
      rethrow;
    }
  }

  // MENGUBAH STATUS LAPORAN
  Future<bool> ubahStatus(
    int id,
    String status,
    String catatan,
  ) async {
    const daftarStatus = [
      'Baru',
      'Diproses',
      'Selesai',
      'Ditolak',
    ];

    try {
      final statusDipilih = daftarStatus.firstWhere(
        (item) => item.toLowerCase() == status.trim().toLowerCase(),
        orElse: () => '',
      );

      if (statusDipilih.isEmpty) {
        return false;
      }

      final berhasil =
          await DBHelper.instance.updateStatusLaporan(
        id: id,
        status: statusDipilih,
        catatan: catatan,
      );

      if (!berhasil) return false;

      await loadLaporan();
      return true;
    } catch (e) {
      debugPrint('Gagal mengubah status: $e');
      return false;
    }
  }

  // MENGGANTI FOTO LAPORAN LAMA
  Future<bool> ubahFotoLaporan(int id, String foto) async {
    try {
      final hasil = await DBHelper.instance.updateFotoLaporan(
        id: id,
        foto: foto,
      );

      if (hasil == 0) return false;

      await loadLaporan();
      return true;
    } catch (e) {
      debugPrint('Gagal mengganti foto laporan: $e');
      return false;
    }
  }

  // MENGAMBIL RIWAYAT STATUS
  Future<List<RiwayatStatusModel>> ambilRiwayatStatus(
    int laporanId,
  ) async {
    try {
      return await DBHelper.instance.getRiwayatStatus(laporanId);
    } catch (e) {
      debugPrint('Gagal mengambil riwayat status: $e');
      return [];
    }
  }

  // MENGHAPUS LAPORAN
  Future<bool> hapusLaporan(int id) async {
    try {
      await DBHelper.instance.deleteLaporan(id);
      await loadLaporan();
      return true;
    } catch (e) {
      debugPrint('Gagal menghapus laporan: $e');
      return false;
    }
  }

  // MENCARI LAPORAN BERDASARKAN ID
  Future<LaporanModel?> cariLaporan(int id) async {
    try {
      return await DBHelper.instance.getLaporanById(id);
    } catch (e) {
      debugPrint('Gagal mencari laporan: $e');
      return null;
    }
  }
}
