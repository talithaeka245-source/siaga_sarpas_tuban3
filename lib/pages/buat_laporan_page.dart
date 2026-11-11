
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/laporan_model.dart';
import '../providers/auth_provider.dart';
import '../providers/laporan_provider.dart';
import 'sukses_page.dart';

class BuatLaporanPage extends StatefulWidget {
  final String kategori;

  const BuatLaporanPage({
    super.key,
    required this.kategori,
  });

  @override
  State<BuatLaporanPage> createState() => _BuatLaporanPageState();
}

class _BuatLaporanPageState extends State<BuatLaporanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _tingkatKerusakan = 'Sedang';
  String? _fotoBase64;
  Uint8List? _fotoBytes;
  bool _isSaving = false;

  Future<void> _ambilFoto(ImageSource source) async {
    try {
      final XFile? hasil = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (hasil == null) return;

      final bytes = await hasil.readAsBytes();
      final encoded = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      if (!mounted) return;

      setState(() {
        _fotoBytes = bytes;
        _fotoBase64 = encoded;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil foto: $e')),
      );
    }
  }

  void _pilihSumberFoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih Foto dari Perangkat'),
                onTap: () {
                  Navigator.pop(context);
                  _ambilFoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _ambilFoto(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _kirimLaporan() async {
    if (!_formKey.currentState!.validate()) return;

    final username = context.read<AuthProvider>().username;

    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final sekarang = DateTime.now();

      final tanggal =
          '${sekarang.day.toString().padLeft(2, '0')}-'
          '${sekarang.month.toString().padLeft(2, '0')}-'
          '${sekarang.year}';

      final data = LaporanModel(
        reporter: username,
        school: 'SMPN 1 Tuban',
        kategori: widget.kategori,
        namaFasilitas: _namaController.text.trim(),
        lokasi: _lokasiController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        tingkatKerusakan: _tingkatKerusakan,
        foto: _fotoBase64,
        tanggal: tanggal,
        status: 'Baru',
      );

      final berhasil = await context
          .read<LaporanProvider>()
          .tambahLaporan(data);

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      if (berhasil) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SuksesPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan laporan. Coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _judul(String teks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        teks,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _fotoBytes == null
                      ? Container(
                          height: 115,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 45,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _fotoBytes!,
                            height: 115,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 115,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Text('Foto tidak dapat ditampilkan'),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pilihSumberFoto,
                    child: Container(
                      height: 115,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF0866B5),
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambah Foto\n(Opsional)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            _judul('Kategori'),

            DropdownButtonFormField<String>(
              initialValue: widget.kategori,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                'Ruang Kelas',
                'Meja & Kursi',
                'Toilet',
                'Listrik',
                'Air',
                'Atap & Plafon',
                'Komputer/Laptop',
                'Olahraga',
                'Perpustakaan',
                'Lainnya',
              ].map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: null,
            ),

            _judul('Nama Fasilitas'),

            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Meja kelas',
                prefixIcon: Icon(Icons.chair),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama fasilitas wajib diisi.';
                }
                return null;
              },
            ),

            _judul('Lokasi / Ruangan'),

            TextFormField(
              controller: _lokasiController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Ruang XI RPL 2',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lokasi wajib diisi.';
                }
                return null;
              },
            ),

            _judul('Deskripsi Masalah'),

            TextFormField(
              controller: _deskripsiController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Jelaskan kerusakan fasilitas...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi masalah wajib diisi.';
                }
                return null;
              },
            ),

            _judul('Tingkat Kerusakan'),

            RadioGroup<String>(
              groupValue: _tingkatKerusakan,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _tingkatKerusakan = value;
                  });
                }
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Ringan'),
                    value: 'Ringan',
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Sedang'),
                    value: 'Sedang',
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Darurat'),
                    value: 'Darurat',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _kirimLaporan,
                icon: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSaving ? 'Mengirim...' : 'Kirim Laporan',
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
