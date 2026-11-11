import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sekolah_provider.dart';

class PengaturanSekolahPage extends StatefulWidget {
  const PengaturanSekolahPage({super.key});

  @override
  State<PengaturanSekolahPage> createState() =>
      _PengaturanSekolahPageState();
}

class _PengaturanSekolahPageState
    extends State<PengaturanSekolahPage> {
  final TextEditingController _namaController = TextEditingController();
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    _namaController.text =
        context.read<SekolahProvider>().namaSekolah;
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final nama = _namaController.text.trim();

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama sekolah tidak boleh kosong.'),
        ),
      );
      return;
    }

    setState(() => _menyimpan = true);

    final berhasil = await context
        .read<SekolahProvider>()
        .simpanNamaSekolah(nama);

    if (!mounted) return;

    setState(() => _menyimpan = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? 'Nama sekolah berhasil diperbarui.'
              : 'Nama sekolah gagal diperbarui.',
        ),
        backgroundColor: berhasil ? Colors.green : Colors.red,
      ),
    );

    if (berhasil) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Sekolah'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.school,
            size: 75,
            color: Color(0xFF0866B5),
          ),
          const SizedBox(height: 18),
          const Text(
            'Nama Sekolah',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masukkan nama sekolah yang akan digunakan pada laporan dan dashboard.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _namaController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.edit),
              hintText: 'Contoh: SMKN 3 Tuban',
              labelText: 'Nama Sekolah',
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _menyimpan ? null : _simpan,
              icon: _menyimpan
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
                _menyimpan ? 'Menyimpan...' : 'Simpan Nama Sekolah',
              ),
            ),
          ),
        ],
      ),
    );
  }
}