
import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFDDEEFF),
            child: Icon(
              Icons.school,
              size: 65,
              color: Color(0xFF0866B5),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'SIAGA Sarpras Tuban',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0866B5),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Sistem Informasi dan Pelaporan '
              'Sarana-Prasarana Sekolah',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Deskripsi Aplikasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'SIAGA Sarpras Tuban merupakan aplikasi yang '
            'dirancang untuk mempermudah pengguna dalam '
            'melaporkan kerusakan sarana dan prasarana sekolah. '
            'Aplikasi ini membantu proses pencatatan, pemantauan, '
            'dan pengelolaan laporan fasilitas sekolah.',
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.6),
          ),
          const SizedBox(height: 25),
          const Text(
            'Fitur Aplikasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          _fitur(Icons.person, 'Login dan Registrasi Pengguna'),
          _fitur(Icons.add_box, 'Pembuatan Laporan Kerusakan'),
          _fitur(Icons.camera_alt, 'Lampiran Foto Fasilitas'),
          _fitur(Icons.history, 'Riwayat dan Status Laporan'),
          _fitur(Icons.admin_panel_settings, 'Pengelolaan oleh Admin'),
          const SizedBox(height: 35),
          const Center(
            child: Text(
              'Versi 1.0.0\n© 2026 SIAGA Sarpras Tuban',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fitur(IconData icon, String judul) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0866B5)),
          const SizedBox(width: 12),
          Expanded(child: Text(judul)),
        ],
      ),
    );
  }
}
