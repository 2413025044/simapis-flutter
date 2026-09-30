import 'package:flutter/material.dart';

import 'login_page.dart';

class ProfilPage extends StatelessWidget {
  final String role;

  const ProfilPage({super.key, required this.role});

  String get nama {
    switch (role) {
      case 'Admin':
        return 'Administrator SIMAPIS';
      case 'Guru':
        return 'Andi Wijaya';
      default:
        return 'Ahmad Rizky';
    }
  }

  String get nomorId {
    switch (role) {
      case 'Admin':
        return 'ADM-001';
      case 'Guru':
        return '1987654321';
      default:
        return '20260001';
    }
  }

  String get jabatan {
    switch (role) {
      case 'Admin':
        return 'Administrator Sistem';
      case 'Guru':
        return 'Guru Informatika';
      default:
        return 'Siswa';
    }
  }

  String get kelas {
    switch (role) {
      case 'Admin':
        return 'Pengelola SIMAPIS';
      case 'Guru':
        return 'Pengajar';
      default:
        return 'XII IPA 1';
    }
  }

  String get email {
    switch (role) {
      case 'Admin':
        return 'admin@simapis.sch.id';
      case 'Guru':
        return 'guru@simapis.sch.id';
      default:
        return 'siswa@simapis.sch.id';
    }
  }

  IconData get profileIcon {
    switch (role) {
      case 'Admin':
        return Icons.admin_panel_settings;
      case 'Guru':
        return Icons.school;
      default:
        return Icons.person;
    }
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: Text('Apakah kamu yakin ingin keluar dari akun $role?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur edit profil siap dihubungkan ke database.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'Profil Akun',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF42A5F5),
                    Color(0xFF1565C0),
                    Color(0xFF0D1117),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: Icon(
                      profileIcon,
                      size: 48,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    role,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _infoCard(
              icon: Icons.badge_outlined,
              title: 'Nomor Identitas',
              value: nomorId,
            ),

            const SizedBox(height: 12),

            _infoCard(
              icon: Icons.work_outline,
              title: 'Jabatan / Status',
              value: jabatan,
            ),

            const SizedBox(height: 12),

            _infoCard(
              icon: Icons.school_outlined,
              title: 'Kelas / Keterangan',
              value: kelas,
            ),

            const SizedBox(height: 12),

            _infoCard(icon: Icons.email_outlined, title: 'Email', value: email),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _editProfile(context);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profil'),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF1565C0)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
