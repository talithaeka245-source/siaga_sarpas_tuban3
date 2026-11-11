
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/laporan_provider.dart';

class FasilitasSeringRusakPage extends StatelessWidget {
  const FasilitasSeringRusakPage({super.key});

  @override
  Widget build(BuildContext context) {
    final laporan = context.watch<LaporanProvider>();

    // Menghitung jumlah laporan berdasarkan nama fasilitas.
    final Map<String, int> jumlahFasilitas = {};

    for (final item in laporan.laporan) {
      final nama = item.namaFasilitas.trim();

      if (nama.isNotEmpty) {
        final key = nama.toLowerCase();

        jumlahFasilitas[key] =
            (jumlahFasilitas[key] ?? 0) + 1;
      }
    }

    final daftarFasilitas = jumlahFasilitas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      appBar: AppBar(
        title: const Text('Fasilitas Sering Rusak'),
        backgroundColor: const Color(0xFF0866B5),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: laporan.loadLaporan,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 35,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Fasilitas Bermasalah',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Diurutkan berdasarkan jumlah laporan kerusakan.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            if (laporan.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (daftarFasilitas.isEmpty)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.build_circle_outlined,
                      color: Colors.grey,
                      size: 55,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada data kerusakan fasilitas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(daftarFasilitas.length, (index) {
                final item = daftarFasilitas[index];

                final namaAsli = laporan.laporan.firstWhere(
                  (data) =>
                      data.namaFasilitas.trim().toLowerCase() ==
                      item.key,
                ).namaFasilitas.trim();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0866B5)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Color(0xFF0866B5),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaAsli,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${item.value} laporan kerusakan',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.build_outlined,
                        color: Color(0xFF0866B5),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
