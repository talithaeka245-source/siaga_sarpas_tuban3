
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/laporan_model.dart';

class DBHelper {
  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _buatTabelRiwayat(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS riwayat_status (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        laporanId INTEGER NOT NULL,
        status TEXT NOT NULL,
        judul TEXT NOT NULL,
        catatan TEXT NOT NULL,
        waktu TEXT NOT NULL
      )
    ''');
  }

  Future<Database> _initDatabase() async {
    final String path;

    if (kIsWeb) {
      path = 'siaga_sarpras_tuban_web.db';
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'siaga_sarpras_tuban.db');
    }

    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE laporan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reporter TEXT NOT NULL,
            school TEXT NOT NULL,
            kategori TEXT NOT NULL,
            namaFasilitas TEXT NOT NULL,
            lokasi TEXT NOT NULL,
            deskripsi TEXT NOT NULL,
            tingkatKerusakan TEXT NOT NULL,
            status TEXT NOT NULL,
            foto TEXT,
            tanggal TEXT NOT NULL,
            catatan TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pengaturan (
            id INTEGER PRIMARY KEY,
            namaSekolah TEXT NOT NULL
          )
        ''');

        await db.insert('pengaturan', {
          'id': 1,
          'namaSekolah': 'SMPN 1 Tuban',
        });

        await _buatTabelRiwayat(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS pengaturan (
              id INTEGER PRIMARY KEY,
              namaSekolah TEXT NOT NULL
            )
          ''');

          await db.insert(
            'pengaturan',
            {
              'id': 1,
              'namaSekolah': 'SMPN 1 Tuban',
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }

        if (oldVersion < 3) {
          await _buatTabelRiwayat(db);

          final laporanLama = await db.query('laporan');

          for (final laporan in laporanLama) {
            final id = laporan['id'] as int;

            final riwayatAda = await db.query(
              'riwayat_status',
              where: 'laporanId = ?',
              whereArgs: [id],
              limit: 1,
            );

            if (riwayatAda.isEmpty) {
              await db.insert('riwayat_status', {
                'laporanId': id,
                'status': laporan['status'] ?? 'Baru',
                'judul': 'Status laporan saat ini',
                'catatan': laporan['catatan'] ?? '',
                'waktu': DateTime.now().toIso8601String(),
              });
            }
          }
        }
      },
    );
  }

  // MENAMBAH LAPORAN
  Future<int> insertLaporan(LaporanModel laporan) async {
    final db = await database;

    return db.transaction((txn) async {
      final data = laporan.toMap();
      data.remove('id');

      final id = await txn.insert('laporan', data);

      await txn.insert('riwayat_status', {
        'laporanId': id,
        'status': laporan.status,
        'judul': 'Laporan dibuat',
        'catatan': laporan.catatan,
        'waktu': DateTime.now().toIso8601String(),
      });

      return id;
    });
  }

  // MENGAMBIL SEMUA LAPORAN
  Future<List<LaporanModel>> getAllLaporan() async {
    final db = await database;

    final result = await db.query(
      'laporan',
      orderBy: 'id DESC',
    );

    return result.map((e) => LaporanModel.fromMap(e)).toList();
  }

  // MENGAMBIL LAPORAN BERDASARKAN PENGGUNA
  Future<List<LaporanModel>> getLaporanByUser(String username) async {
    final db = await database;

    final result = await db.query(
      'laporan',
      where: 'reporter = ?',
      whereArgs: [username],
      orderBy: 'id DESC',
    );

    return result.map((e) => LaporanModel.fromMap(e)).toList();
  }

  // MENGAMBIL LAPORAN BERDASARKAN ID
  Future<LaporanModel?> getLaporanById(int id) async {
    final db = await database;

    final result = await db.query(
      'laporan',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return LaporanModel.fromMap(result.first);
  }

  // MEMPERBARUI LAPORAN
  Future<int> updateLaporan(LaporanModel laporan) async {
    final db = await database;

    final data = laporan.toMap();
    data.remove('id');

    return db.update(
      'laporan',
      data,
      where: 'id = ?',
      whereArgs: [laporan.id],
    );
  }

  // MEMPERBARUI FOTO LAPORAN LAMA
  Future<int> updateFotoLaporan({
    required int id,
    required String foto,
  }) async {
    final db = await database;

    return db.update(
      'laporan',
      {'foto': foto},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // MENGHAPUS LAPORAN DAN RIWAYATNYA
  Future<int> deleteLaporan(int id) async {
    final db = await database;

    return db.transaction((txn) async {
      await txn.delete(
        'riwayat_status',
        where: 'laporanId = ?',
        whereArgs: [id],
      );

      return txn.delete(
        'laporan',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  // MENGUBAH STATUS LAPORAN
  Future<bool> updateStatusLaporan({
    required int id,
    required String status,
    required String catatan,
  }) async {
    final db = await database;

    return db.transaction((txn) async {
      final hasil = await txn.update(
        'laporan',
        {
          'status': status,
          'catatan': catatan,
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      if (hasil == 0) return false;

      String judul;

      switch (status.toLowerCase()) {
        case 'baru':
          judul = 'Laporan diterima';
          break;
        case 'diproses':
          judul = 'Laporan sedang diproses';
          break;
        case 'selesai':
          judul = 'Laporan telah selesai';
          break;
        case 'ditolak':
          judul = 'Laporan ditolak';
          break;
        default:
          judul = 'Status laporan diperbarui';
      }

      await txn.insert('riwayat_status', {
        'laporanId': id,
        'status': status,
        'judul': judul,
        'catatan': catatan,
        'waktu': DateTime.now().toIso8601String(),
      });

      return true;
    });
  }

  // MENGAMBIL RIWAYAT STATUS
  Future<List<RiwayatStatusModel>> getRiwayatStatus(
    int laporanId,
  ) async {
    final db = await database;

    final result = await db.query(
      'riwayat_status',
      where: 'laporanId = ?',
      whereArgs: [laporanId],
      orderBy: 'id ASC',
    );

    return result
        .map((e) => RiwayatStatusModel.fromMap(e))
        .toList();
  }

  // MENGAMBIL NAMA SEKOLAH
  Future<String?> getNamaSekolah() async {
    final db = await database;

    final result = await db.query(
      'pengaturan',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first['namaSekolah'] as String?;
  }

  // MENYIMPAN NAMA SEKOLAH
  Future<void> simpanNamaSekolah(String nama) async {
    final db = await database;

    await db.insert(
      'pengaturan',
      {
        'id': 1,
        'namaSekolah': nama,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
