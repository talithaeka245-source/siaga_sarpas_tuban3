
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/laporan_provider.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthProvider>().username;
    final laporan = context.watch<LaporanProvider>()
        .laporanPengguna(username ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: laporan.isEmpty
          ? const Center(
              child: Text('Belum ada notifikasi.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: laporan.length,
              itemBuilder: (context, index) {
                final item = laporan[index];

                IconData icon = Icons.notifications_active;
                Color warna = Colors.blue;

                if (item.status == 'Selesai') {
                  icon = Icons.check_circle;
                  warna = Colors.green;
                } else if (item.status == 'Ditolak') {
                  icon = Icons.cancel;
                  warna = Colors.red;
                } else if (item.status == 'Diproses') {
                  icon = Icons.sync;
                  warna = Colors.orange;
                }

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: warna.withValues(alpha: 0.12),
                      child: Icon(icon, color: warna),
                    ),
                    title: Text(
                      'Laporan ${item.namaFasilitas}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Status laporan: ${item.status}\n${item.tanggal}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
