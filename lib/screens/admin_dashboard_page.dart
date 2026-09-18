import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Belum ada notifikasi baru'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings_outlined,
                color: Color(0xFF1565C0),
              ),
            ),
          ),
        ],
      ),

      // =========================
      // BODY
      // =========================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // HEADER ADMIN
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 34,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Admin! 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Kelola data sekolah melalui SIMAPIS',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =========================
            // JUDUL STATISTIK
            // =========================
            const Text(
              'Ringkasan Data',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1117),
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // STATISTIK BARIS 1
            // =========================
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.people_alt_outlined,
                    title: 'Total Siswa',
                    value: '320',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.school_outlined,
                    title: 'Total Guru',
                    value: '35',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =========================
            // STATISTIK BARIS 2
            // =========================
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.how_to_reg_outlined,
                    title: 'Hadir Hari Ini',
                    value: '295',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.warning_amber_outlined,
                    title: 'Pelanggaran',
                    value: '18',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // =========================
            // MENU KELOLA DATA
            // =========================
            const Text(
              'Kelola Data',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1117),
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _menuCard(
                  icon: Icons.people_outline,
                  title: 'Data Siswa',
                  subtitle: 'Kelola siswa',
                  onTap: () {
                    _showMessage(context, 'Data Siswa');
                  },
                ),
                _menuCard(
                  icon: Icons.person_outline,
                  title: 'Data Guru',
                  subtitle: 'Kelola guru',
                  onTap: () {
                    _showMessage(context, 'Data Guru');
                  },
                ),
                _menuCard(
                  icon: Icons.class_outlined,
                  title: 'Data Kelas',
                  subtitle: 'Kelola kelas',
                  onTap: () {
                    _showMessage(context, 'Data Kelas');
                  },
                ),
                _menuCard(
                  icon: Icons.assignment_turned_in_outlined,
                  title: 'Absensi',
                  subtitle: 'Kelola absensi',
                  onTap: () {
                    _showMessage(context, 'Input Absensi');
                  },
                ),
                _menuCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Pelanggaran',
                  subtitle: 'Kelola pelanggaran',
                  onTap: () {
                    _showMessage(context, 'Pelanggaran');
                  },
                ),
                _menuCard(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  subtitle: 'Kelola notifikasi',
                  onTap: () {
                    _showMessage(context, 'Notifikasi');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // =========================
            // LAPORAN
            // =========================
            const Text(
              'Laporan & Peraturan',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1117),
              ),
            ),

            const SizedBox(height: 12),

            _largeMenuCard(
              icon: Icons.assessment_outlined,
              title: 'Laporan Kelas',
              subtitle: 'Lihat dan cetak laporan absensi siswa',
              onTap: () {
                _showMessage(context, 'Laporan Kelas');
              },
            ),

            const SizedBox(height: 12),

            _largeMenuCard(
              icon: Icons.menu_book_outlined,
              title: 'Tata Tertib',
              subtitle: 'Kelola aturan dan poin pelanggaran',
              onTap: () {
                _showMessage(context, 'Tata Tertib');
              },
            ),

            const SizedBox(height: 12),

            _largeMenuCard(
              icon: Icons.settings_outlined,
              title: 'Pengaturan',
              subtitle: 'Pengaturan sistem dan akun',
              onTap: () {
                _showMessage(context, 'Pengaturan');
              },
            ),

            const SizedBox(height: 24),

            // =========================
            // PELANGGARAN TERBARU
            // =========================
            const Text(
              'Pelanggaran Terbaru',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1117),
              ),
            ),

            const SizedBox(height: 12),

            _violationCard(
              name: 'Ahmad Rizky',
              violation: 'Terlambat masuk sekolah',
              point: '5 poin',
              date: 'Hari ini',
            ),

            const SizedBox(height: 10),

            _violationCard(
              name: 'Siti Aulia',
              violation: 'Tidak menggunakan atribut lengkap',
              point: '10 poin',
              date: 'Hari ini',
            ),

            const SizedBox(height: 10),

            _violationCard(
              name: 'Budi Pratama',
              violation: 'Tidak mengikuti upacara',
              point: '15 poin',
              date: 'Kemarin',
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Absensi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_outlined),
            label: 'Pelanggaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // =====================================================
  // STAT CARD
  // =====================================================

  static Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1565C0), size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0D1117),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MENU CARD
  // =====================================================

  static Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF1565C0), size: 27),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // LARGE MENU CARD
  // =====================================================

  static Widget _largeMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 27),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // PELANGGARAN CARD
  // =====================================================

  static Widget _violationCard({
    required String name,
    required String violation,
    required String point,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  violation,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              point,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PESAN SEMENTARA
  // =====================================================

  static void _showMessage(BuildContext context, String menu) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$menu akan dibuat selanjutnya'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
