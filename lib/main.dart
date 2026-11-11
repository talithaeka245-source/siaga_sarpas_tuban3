
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'pages/splash_page.dart';
import 'providers/auth_provider.dart';
import 'providers/laporan_provider.dart';
import 'providers/sekolah_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DATABASE CHROME / WEB
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // DATABASE WINDOWS
  else if (defaultTargetPlatform == TargetPlatform.windows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // ANDROID tetap menggunakan database SQLite bawaan.

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LaporanProvider()..loadLaporan(),
        ),
        ChangeNotifierProvider(
          create: (_) => SekolahProvider()..loadNamaSekolah(),
        ),
      ],
      child: const SiagaSarprasApp(),
    ),
  );
}

class SiagaSarprasApp extends StatelessWidget {
  const SiagaSarprasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIAGA Sarpras Tuban',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0866B5),
          primary: const Color(0xFF0866B5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0866B5),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0866B5),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}
