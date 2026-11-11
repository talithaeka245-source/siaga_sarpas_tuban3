
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/laporan_model.dart';
import '../providers/laporan_provider.dart';
import 'detail_laporan_page.dart';
import 'update_status_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Color _warnaStatus(String status) {
    switch (status.trim().toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.blue;
      case 'ditolak':
        return Colors.red;
      case 'baru':
      default:
        return Colors.orange;
    }
  }

  Future<void> _bukaVerifikasi(
    BuildContext context,
    LaporanModel item,
  ) async {
    if (item.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID laporan tidak ditemukan.'),
        ),
      );
      return;
    }

    final hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateStatusPage(
          laporanId: item.id!,
        ),
      ),
    );

    if (!context.mounted) return;

    if (hasil == true) {
      await context.read<LaporanProvider>().loadLaporan();
    }
  }

  void _bukaDetail(BuildContext context, LaporanModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailLaporanPage(
          laporan: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LaporanProvider>();
    final daftarLaporan = provider.laporan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Laporan'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading
                ? null
                : () {
                    context.read<LaporanProvider>().loadLaporan();
                  },
          ),
        ],
      ),
      body: provider.isLoading && daftarLaporan.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : daftarLaporan.isEmpty
              ? RefreshIndicator(
                  onRefresh: () =>
                      context.read<LaporanProvider>().loadLaporan(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 180),
                      Icon(
                        Icons.assignment_outlined,
                        size: 65,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: Text(
                          'Belum ada laporan masuk.',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      context.read<LaporanProvider>().loadLaporan(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(14),
                    itemCount: daftarLaporan.length,
                    itemBuilder: (context, index) {
                      final LaporanModel item = daftarLaporan[index];
                      final warna = _warnaStatus(item.status);

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 13),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.assignment,
                                    color: Color(0xFF0866B5),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      item.namaFasilitas,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: warna.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item.status,
                                      style: TextStyle(
                                        color: warna,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('Pelapor: ${item.reporter}'),
                              const SizedBox(height: 5),
                              Text('Kategori: ${item.kategori}'),
                              const SizedBox(height: 5),
                              Text('Lokasi: ${item.lokasi}'),
                              const SizedBox(height: 5),
                              Text('Tanggal: ${item.tanggal}'),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      icon: const Icon(Icons.visibility),
                                      label: const Text('Detail'),
                                      onPressed: () {
                                        _bukaDetail(context, item);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Verifikasi'),
                                      onPressed: item.id == null
                                          ? null
                                          : () {
                                              _bukaVerifikasi(
                                                context,
                                                item,
                                              );
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
