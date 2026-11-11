
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/laporan_model.dart';
import '../providers/laporan_provider.dart';

class DetailLaporanPage extends StatelessWidget {
  final LaporanModel laporan;

  const DetailLaporanPage({
    super.key,
    required this.laporan,
  });

  Color _warnaStatus(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.blue;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatTanggal(DateTime waktu) {
    String duaDigit(int angka) => angka.toString().padLeft(2, '0');

    return '${duaDigit(waktu.day)}-${duaDigit(waktu.month)}-'
        '${waktu.year} ${duaDigit(waktu.hour)}:${duaDigit(waktu.minute)}';
  }

  IconData _ikonRiwayat(String judul) {
    final teks = judul.toLowerCase();

    if (teks.contains('diterima')) {
      return Icons.assignment_turned_in;
    } else if (teks.contains('diverifikasi')) {
      return Icons.verified;
    } else if (teks.contains('proses')) {
      return Icons.build_circle;
    } else if (teks.contains('selesai')) {
      return Icons.check_circle;
    } else if (teks.contains('ditolak')) {
      return Icons.cancel;
    } else {
      return Icons.edit_note;
    }
  }

  Color _warnaRiwayat(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.blue;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _gantiFoto(BuildContext context) async {
    if (laporan.id == null) return;

    final provider = context.read<LaporanProvider>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      final picker = ImagePicker();

      final hasil = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (hasil == null) return;

      final bytes = await hasil.readAsBytes();

      final fotoBase64 =
          'data:image/jpeg;base64,${base64Encode(bytes)}';

      final berhasil = await provider.ubahFotoLaporan(
        laporan.id!,
        fotoBase64,
      );

      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            berhasil
                ? 'Foto laporan berhasil diperbarui!'
                : 'Foto laporan gagal diperbarui.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  Widget _gambarFoto({
    required String? foto,
    required double height,
  }) {
    if (foto == null || foto.isEmpty) {
      return _placeholderFoto(height);
    }

    if (foto.startsWith('data:image/')) {
      try {
        final bagian = foto.split(',');
        if (bagian.length < 2) return _placeholderFoto(height);

        final bytes = base64Decode(bagian.last);

        return Image.memory(
          bytes,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderFoto(height);
          },
        );
      } catch (_) {
        return _placeholderFoto(height);
      }
    }

    if (!kIsWeb) {
      return Image.file(
        File(foto),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _placeholderFoto(height);
        },
      );
    }

    return _placeholderFoto(height);
  }

  Widget _placeholderFoto(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Text('Foto tidak dapat ditampilkan'),
    );
  }

  Widget _info(String judul, String isi, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF0866B5),
            size: 25,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  isi.isEmpty ? '-' : isi,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required RiwayatStatusModel item,
    required bool terakhir,
  }) {
    final warna = _warnaRiwayat(item.status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 19,
                  height: 19,
                  decoration: BoxDecoration(
                    color: warna.withValues(alpha: 0.13),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _ikonRiwayat(item.judul),
                    color: warna,
                    size: 13,
                  ),
                ),
                if (!terakhir)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatTanggal(item.waktu),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                  if (item.catatan.trim().isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      'Catatan: ${item.catatan}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LaporanProvider>();

    final laporanTerbaru = laporan.id == null
        ? laporan
        : provider.laporan.firstWhere(
            (item) => item.id == laporan.id,
            orElse: () => laporan,
          );

    final statusColor = _warnaStatus(laporanTerbaru.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      appBar: AppBar(
        title: const Text('Detail Laporan'),
        backgroundColor: const Color(0xFF0866B5),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _gambarFoto(
                  foto: laporanTerbaru.foto,
                  height: 190,
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 8,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        laporanTerbaru.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            laporanTerbaru.namaFasilitas,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Laporan',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    laporanTerbaru.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(height: 35),

                _info('Nama Pelapor', laporanTerbaru.reporter, Icons.person),
                _info('Sekolah', laporanTerbaru.school, Icons.school),
                _info('Kategori', laporanTerbaru.kategori, Icons.category),
                _info(
                  'Nama Fasilitas',
                  laporanTerbaru.namaFasilitas,
                  Icons.inventory_2,
                ),
                _info('Lokasi', laporanTerbaru.lokasi, Icons.location_on),
                _info(
                  'Tanggal Laporan',
                  laporanTerbaru.tanggal,
                  Icons.calendar_month,
                ),
                _info(
                  'Tingkat Kerusakan',
                  laporanTerbaru.tingkatKerusakan,
                  Icons.warning_amber,
                ),
                _info(
                  'Deskripsi',
                  laporanTerbaru.deskripsi,
                  Icons.description,
                ),
                _info(
                  'Catatan Admin',
                  laporanTerbaru.catatan.isEmpty
                      ? '-'
                      : laporanTerbaru.catatan,
                  Icons.comment,
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Update Terakhir',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            child: laporan.id == null
                ? const Text('Riwayat status belum tersedia.')
                : FutureBuilder<List<RiwayatStatusModel>>(
                    future: context
                        .read<LaporanProvider>()
                        .ambilRiwayatStatus(laporan.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Text(
                          'Gagal memuat riwayat status.',
                        );
                      }

                      final riwayat = snapshot.data ?? [];

                      if (riwayat.isEmpty) {
                        return const Text(
                          'Riwayat status belum tersedia untuk laporan lama ini.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        );
                      }

                      return Column(
                        children: List.generate(
                          riwayat.length,
                          (index) => _timelineItem(
                            item: riwayat[index],
                            terakhir: index == riwayat.length - 1,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Foto Laporan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _gambarFoto(
              foto: laporanTerbaru.foto,
              height: 220,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _gantiFoto(context),
              icon: const Icon(Icons.photo_library),
              label: const Text('Ganti Foto dari Galeri'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0866B5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
