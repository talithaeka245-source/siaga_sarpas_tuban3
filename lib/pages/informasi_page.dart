
import 'package:flutter/material.dart';

class InformasiPage extends StatelessWidget {
  const InformasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 15),

          const Center(
            child: Icon(
              Icons.info_outline,
              size: 75,
              color: Color(0xFF0866B5),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'SIAGA Sarpras Tuban',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0866B5),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'SIAGA Sarpras Tuban merupakan aplikasi '
            'Sistem Informasi dan Pelaporan Sarana '
            'Prasarana Sekolah di Kabupaten Tuban.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Tujuan Aplikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Membantu pengguna melaporkan kerusakan '
            'dan permasalahan sarana prasarana sekolah '
            'agar dapat ditindaklanjuti dengan lebih mudah.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Fitur Aplikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _fitur(Icons.add_circle_outline, 'Membuat laporan kerusakan fasilitas'),
          _fitur(Icons.history, 'Melihat riwayat laporan'),
          _fitur(Icons.track_changes, 'Memantau status laporan'),
          _fitur(Icons.admin_panel_settings, 'Pengelolaan laporan oleh admin'),
          _fitur(Icons.notifications_outlined, 'Menerima informasi laporan'),

          const SizedBox(height: 25),

          const Center(
            child: Text(
              'SIAGA Sarpras Tuban',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _fitur(IconData icon, String judul) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF0866B5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(judul),
          ),
        ],
      ),
    );
  }
}
