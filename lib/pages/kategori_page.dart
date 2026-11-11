import 'package:flutter/material.dart';
import 'buat_laporan_page.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  final List<Map<String, dynamic>> kategori = const [
    {
      'nama': 'Ruang Kelas',
      'icon': Icons.meeting_room,
      'warna': Color(0xFF36B879),
    },
    {
      'nama': 'Meja & Kursi',
      'icon': Icons.chair,
      'warna': Color(0xFFFFB52E),
    },
    {
      'nama': 'Toilet',
      'icon': Icons.wc,
      'warna': Color(0xFF3195E5),
    },
    {
      'nama': 'Listrik',
      'icon': Icons.bolt,
      'warna': Color(0xFFFFA726),
    },
    {
      'nama': 'Air',
      'icon': Icons.water_drop,
      'warna': Color(0xFF2196F3),
    },
    {
      'nama': 'Atap & Plafon',
      'icon': Icons.roofing,
      'warna': Color(0xFF9C59C7),
    },
    {
      'nama': 'Komputer/Laptop',
      'icon': Icons.computer,
      'warna': Color(0xFF2196F3),
    },
    {
      'nama': 'Olahraga',
      'icon': Icons.sports_basketball,
      'warna': Color(0xFFE85D75),
    },
    {
      'nama': 'Perpustakaan',
      'icon': Icons.menu_book,
      'warna': Color(0xFF38A56B),
    },
    {
      'nama': 'Lainnya',
      'icon': Icons.category,
      'warna': Color(0xFFAB59D1),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Sarpras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kategori...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {},
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: kategori.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final item = kategori[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BuatLaporanPage(
                            kategori: item['nama'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: (item['warna'] as Color)
                                  .withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: item['warna'] as Color,
                              size: 30,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            item['nama'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}