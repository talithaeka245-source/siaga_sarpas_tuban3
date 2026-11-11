
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'kategori_page.dart';
import 'riwayat_page.dart';
import 'notifikasi_page.dart';
import 'profil_page.dart';
import 'informasi_page.dart';
import 'dashboard_sarpras_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _bukaHalaman(Widget halaman) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => halaman),
    );
  }

  void _pindahTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _menuCard({
    required String judul,
    required IconData ikon,
    required Color warna,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 18,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  ikon,
                  color: warna,
                  size: 28,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                judul,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263238),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeranda() {
    final username = context.watch<AuthProvider>().username;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0866B5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat Datang,',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                username ?? 'Pengguna',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sistem Informasi Aduan Sarana dan Prasarana Sekolah',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Menu Utama',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: [
            _menuCard(
              judul: 'Buat Laporan',
              ikon: Icons.add_circle_outline,
              warna: Colors.blue,
              onTap: () => _bukaHalaman(const KategoriPage()),
            ),
            _menuCard(
              judul: 'Riwayat Laporan',
              ikon: Icons.history,
              warna: Colors.orange,
              onTap: () => _pindahTab(1),
            ),
            _menuCard(
              judul: 'Informasi KK',
              ikon: Icons.info_outline,
              warna: Colors.green,
              onTap: () => _bukaHalaman(const InformasiPage()),
            ),
            _menuCard(
              judul: 'Profil',
              ikon: Icons.person_outline,
              warna: Colors.purple,
              onTap: () => _pindahTab(3),
            ),
            _menuCard(
              judul: 'Dashboard Sarpras',
              ikon: Icons.dashboard_outlined,
              warna: Colors.teal,
              onTap: () => _bukaHalaman(
                const DashboardSarprasPage(),
              ),
            ),
            _menuCard(
              judul: 'Notifikasi',
              ikon: Icons.notifications_none,
              warna: Colors.red,
              onTap: () => _pindahTab(2),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final halaman = [
      _buildBeranda(),
      const RiwayatPage(),
      const NotifikasiPage(),
      const ProfilPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SIAGA Sarpras Tuban',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0866B5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _pindahTab(2),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: halaman,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _pindahTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0866B5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
