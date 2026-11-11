
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final Map<String, String> _accounts = {
    'siswa': 'siswa123',
    'andi': 'siswa123',
    'admin': 'admin123',
  };

  String? _username;
  bool _isAdmin = false;

  String? get username => _username;
  bool get isAdmin => _isAdmin;
  bool get isLoggedIn => _username != null;

  String? login(String username, String password) {
    final user = username.trim().toLowerCase();

    if (user.isEmpty || password.isEmpty) {
      return 'Username dan password wajib diisi.';
    }

    if (!_accounts.containsKey(user) || _accounts[user] != password) {
      return 'Username atau password salah.';
    }

    _username = user;
    _isAdmin = user == 'admin';

    notifyListeners();
    return null;
  }

  String? register(String username, String password) {
    final user = username.trim().toLowerCase();

    if (user.isEmpty || password.isEmpty) {
      return 'Semua kolom wajib diisi.';
    }

    if (user.length < 3) {
      return 'Username minimal 3 karakter.';
    }

    if (password.length < 6) {
      return 'Password minimal 6 karakter.';
    }

    if (_accounts.containsKey(user)) {
      return 'Username sudah digunakan.';
    }

    _accounts[user] = password;

    notifyListeners();
    return null;
  }

  // Mengubah username akun yang sedang login.
  String? ubahUsername(String usernameBaru) {
    if (_username == null) {
      return 'Silakan login terlebih dahulu.';
    }

    final userBaru = usernameBaru.trim().toLowerCase();

    if (userBaru.isEmpty) {
      return 'Username tidak boleh kosong.';
    }

    if (userBaru.length < 3) {
      return 'Username minimal 3 karakter.';
    }

    if (_accounts.containsKey(userBaru) && userBaru != _username) {
      return 'Username sudah digunakan.';
    }

    final passwordLama = _accounts[_username];

    _accounts.remove(_username);
    _accounts[userBaru] = passwordLama!;

    _username = userBaru;

    notifyListeners();
    return null;
  }

  // Mengganti password akun yang sedang login.
  String? gantiPassword(
    String passwordLama,
    String passwordBaru,
  ) {
    if (_username == null) {
      return 'Silakan login terlebih dahulu.';
    }

    if (passwordLama.isEmpty || passwordBaru.isEmpty) {
      return 'Semua kolom wajib diisi.';
    }

    if (_accounts[_username] != passwordLama) {
      return 'Password lama tidak sesuai.';
    }

    if (passwordBaru.length < 6) {
      return 'Password baru minimal 6 karakter.';
    }

    _accounts[_username!] = passwordBaru;

    notifyListeners();
    return null;
  }

  void logout() {
    _username = null;
    _isAdmin = false;
    notifyListeners();
  }
}
