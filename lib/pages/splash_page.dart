
import 'dart:async';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  static const Color biru = Color(0xFF0866B5);

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F1FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: biru,
                    size: 75,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'SIAGA',
                  style: TextStyle(
                    color: biru,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Sarpras Tuban',
                  style: TextStyle(
                    color: biru,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Sistem Informasi dan Pengaduan\n'
                  'Sarana Prasarana Sekolah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: biru,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Memuat aplikasi...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
