
import 'package:flutter/material.dart';

import '../models/laporan_model.dart';

class LaporanCard extends StatelessWidget {
  final LaporanModel laporan;
  final VoidCallback? onTap;

  const LaporanCard({
    super.key,
    required this.laporan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color warna;

    switch (laporan.status) {
      case 'Selesai':
        warna = Colors.green;
        break;
      case 'Diproses':
        warna = Colors.orange;
        break;
      case 'Ditolak':
        warna = Colors.red;
        break;
      default:
        warna = Colors.blue;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE3F1FF),
                child: Icon(
                  Icons.build_circle,
                  color: Color(0xFF0866B5),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      laporan.namaFasilitas,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      laporan.kategori,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      laporan.tanggal,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  laporan.status,
                  style: TextStyle(
                    color: warna,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
