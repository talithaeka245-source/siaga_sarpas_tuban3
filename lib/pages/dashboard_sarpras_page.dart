
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/laporan_provider.dart';

class DashboardSarprasPage extends StatelessWidget {
  const DashboardSarprasPage({super.key});

  Widget _kartuStatistik({
    required String judul,
    required int jumlah,
    required Color warna,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: warna, size: 30),
          const SizedBox(height: 10),
          Text(
            judul,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$jumlah',
            style: TextStyle(
              color: warna,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final laporan = context.watch<LaporanProvider>();

    final namaSekolah = laporan.laporan.isNotEmpty
        ? laporan.laporan.first.school
        : 'Belum ada data sekolah';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FC),
      appBar: AppBar(
        title: const Text('Dashboard Sarpras'),
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
              child: Row(
                children: [
                  const Icon(
                    Icons.school,
                    color: Color(0xFF0866B5),
                    size: 38,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Sekolah',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          namaSekolah,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0866B5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 38,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Total Laporan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    '${laporan.totalLaporan}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Statistik Laporan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                _kartuStatistik(
                  judul: 'Baru',
                  jumlah: laporan.laporanBaru,
                  warna: Colors.red,
                  icon: Icons.assignment_outlined,
                ),
                _kartuStatistik(
                  judul: 'Diproses',
                  jumlah: laporan.laporanDiproses,
                  warna: Colors.orange,
                  icon: Icons.pending_actions,
                ),
                _kartuStatistik(
                  judul: 'Selesai',
                  jumlah: laporan.laporanSelesai,
                  warna: Colors.green,
                  icon: Icons.check_circle_outline,
                ),
                _kartuStatistik(
                  judul: 'Ditolak',
                  jumlah: laporan.laporanDitolak,
                  warna: Colors.redAccent,
                  icon: Icons.cancel_outlined,
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (laporan.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
