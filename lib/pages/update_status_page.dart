
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/laporan_provider.dart';

class UpdateStatusPage extends StatefulWidget {
  final int laporanId;

  const UpdateStatusPage({
    super.key,
    required this.laporanId,
  });

  @override
  State<UpdateStatusPage> createState() => _UpdateStatusPageState();
}

class _UpdateStatusPageState extends State<UpdateStatusPage> {
  final TextEditingController _catatanController =
      TextEditingController();

  final List<String> _daftarStatus = [
    'Baru',
    'Diproses',
    'Selesai',
    'Ditolak',
  ];

  String? _status;
  bool _saving = false;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_status == null || _saving) return;

    setState(() {
      _saving = true;
    });

    try {
      final berhasil =
          await context.read<LaporanProvider>().ubahStatus(
                widget.laporanId,
                _status!,
                _catatanController.text.trim(),
              );

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status laporan berhasil diperbarui.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memperbarui status laporan.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LaporanProvider>();

    final hasil = provider.laporan.where(
      (item) => item.id == widget.laporanId,
    );

    if (hasil.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Status'),
        ),
        body: const Center(
          child: Text('Data laporan tidak ditemukan.'),
        ),
      );
    }

    final laporan = hasil.first;

    _status ??= _daftarStatus.contains(laporan.status)
        ? laporan.status
        : 'Baru';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Status Laporan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Laporan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  laporan.namaFasilitas,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Pelapor: ${laporan.reporter}'),
                const SizedBox(height: 5),
                Text('Sekolah: ${laporan.school}'),
                const SizedBox(height: 5),
                Text('Kategori: ${laporan.kategori}'),
                const SizedBox(height: 5),
                Text('Lokasi: ${laporan.lokasi}'),
                const SizedBox(height: 5),
                Text('Tanggal: ${laporan.tanggal}'),
                const SizedBox(height: 5),
                Text('Status saat ini: ${laporan.status}'),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Pilih Status Laporan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 9),

          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sync),
              hintText: 'Pilih status',
            ),
            items: _daftarStatus.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _status = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Catatan Admin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 9),

          TextField(
            controller: _catatanController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Masukkan catatan atau keterangan untuk pelapor...',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _simpan,
              icon: _saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _saving ? 'Menyimpan...' : 'Simpan Perubahan',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
