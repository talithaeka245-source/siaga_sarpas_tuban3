
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'admin_page.dart';
import 'login_page.dart';
import 'tentang_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  // Dialog untuk mengubah username.
  Future<void> _ubahProfil(
    BuildContext context,
    AuthProvider auth,
  ) async {
    final controller = TextEditingController(
      text: auth.username ?? '',
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ubah Profil'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Username Baru',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final hasil = auth.ubahUsername(controller.text);

                if (hasil != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(hasil)),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Username berhasil diperbarui.'),
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  // Dialog untuk mengganti password.
  Future<void> _gantiPassword(
    BuildContext context,
    AuthProvider auth,
  ) async {
    final passwordLamaController = TextEditingController();
    final passwordBaruController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ganti Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordLamaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Lama',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordBaruController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final hasil = auth.gantiPassword(
                  passwordLamaController.text,
                  passwordBaruController.text,
                );

                if (hasil != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(hasil)),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password berhasil diganti.'),
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    passwordLamaController.dispose();
    passwordBaruController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFDDEEFF),
            child: Icon(
              Icons.person,
              size: 65,
              color: Color(0xFF0866B5),
            ),
          ),

          const SizedBox(height: 15),

          Center(
            child: Text(
              auth.username ?? 'Pengguna',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),

          Center(
            child: Text(
              auth.isAdmin ? 'Administrator' : 'Pengguna',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Username'),
                  subtitle: Text(auth.username ?? '-'),
                ),

                const Divider(height: 1),

                // Menu Ubah Profil.
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF0866B5),
                  ),
                  title: const Text('Ubah Profil'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _ubahProfil(context, auth);
                  },
                ),

                const Divider(height: 1),

                // Menu Ganti Password.
                ListTile(
                  leading: const Icon(
                    Icons.lock_outline,
                    color: Color(0xFF0866B5),
                  ),
                  title: const Text('Ganti Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _gantiPassword(context, auth);
                  },
                ),

                const Divider(height: 1),

                const ListTile(
                  leading: Icon(Icons.school_outlined),
                  title: Text('Aplikasi'),
                  subtitle: Text('SIAGA Sarpras Tuban'),
                ),

                if (auth.isAdmin) ...[
                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF0866B5),
                    ),
                    title: const Text('Dashboard Admin'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminPage(),
                        ),
                      );
                    },
                  ),
                ],

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Tentang Aplikasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TentangPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Keluar Aplikasi?'),
                      content: const Text(
                        'Apakah kamu yakin ingin keluar?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthProvider>().logout();

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('Keluar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
