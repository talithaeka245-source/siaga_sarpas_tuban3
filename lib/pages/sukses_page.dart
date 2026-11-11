import 'package:flutter/material.dart';
import 'home_page.dart';

class SuksesPage extends StatelessWidget {
  const SuksesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFF1C9A59),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 65,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Laporan Berhasil Dikirim!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF16864B),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Terima kasih telah melaporkan kerusakan '
                'sarana-prasarana sekolah. Laporan Anda '
                'akan segera diverifikasi oleh pihak sekolah.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  height: 1.6,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 45),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Kembali ke Beranda'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Selesai'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}