import 'package:flutter/material.dart';

import 'absensi_page.dart';
import 'siswa_page.dart';
import 'guru_page.dart';
import 'kelas_page.dart';
import 'pelanggaran_page.dart';
import 'notifikasi_page.dart';
import 'laporan_page.dart';
import 'tata_tertib_page.dart';
import 'profil_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _darkMode = false;

  static const Color _blue = Color(0xFF2864F0);
  static const Color _cyan = Color(0xFF16B8D4);

  Color get _background =>
      _darkMode ? const Color(0xFF101827) : const Color(0xFFF0F6FF);

  Color get _surface => _darkMode ? const Color(0xFF1B2638) : Colors.white;

  Color get _text => _darkMode ? Colors.white : const Color(0xFF141D32);

  Color get _muted => _darkMode ? Colors.white70 : const Color(0xFF8A9BB5);

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _navigateFromMenu(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    final isDrawerOpen = Scaffold.of(context).isDrawerOpen;

    if (isDrawerOpen) {
      navigator.pop();
    }

    _openPage(context, page);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showLogoutMessage() {
    _showMessage('Fitur keluar perlu dihubungkan dengan halaman login.');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 950;

    return Scaffold(
      backgroundColor: _background,

      // Di HP, menu ditampilkan melalui drawer.
      // Di laptop, menu tampil sebagai sidebar permanen.
      drawer: isDesktop
          ? null
          : Drawer(backgroundColor: _surface, child: _buildSidebar(context)),

      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: _surface,
              foregroundColor: _text,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: _text,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Selamat datang kembali!',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
              actions: _buildHeaderActions(),
            ),

      body: isDesktop
          ? Row(
              children: [
                SizedBox(width: 260, child: _buildSidebar(context)),
                Expanded(
                  child: Column(
                    children: [
                      _buildDesktopHeader(),
                      Expanded(
                        child: _buildDashboardContent(context, isDesktop: true),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : _buildDashboardContent(context, isDesktop: false),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildDesktopHeader() {
    return Container(
      color: _surface,
      padding: const EdgeInsets.fromLTRB(28, 16, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selamat datang kembali!',
                  style: TextStyle(fontSize: 15, color: _muted),
                ),
              ],
            ),
          ),
          ..._buildHeaderActions(),
        ],
      ),
    );
  }

  List<Widget> _buildHeaderActions() {
    return [
      IconButton(
        tooltip: _darkMode ? 'Mode terang' : 'Mode gelap',
        onPressed: () {
          setState(() {
            _darkMode = !_darkMode;
          });
        },
        icon: Icon(
          _darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        ),
      ),
      IconButton(
        tooltip: 'Notifikasi',
        onPressed: () {
          _openPage(context, const NotifikasiPage());
        },
        icon: const Icon(Icons.notifications_none_rounded),
      ),
      IconButton(
        tooltip: 'Keluar',
        onPressed: _showLogoutMessage,
        icon: const Icon(Icons.logout_rounded),
      ),
    ];
  }

  // =========================================================
  // SIDEBAR / DRAWER
  // =========================================================

  Widget _buildSidebar(BuildContext context) {
    return Container(
      color: _surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 16, 22),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_blue, _cyan]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_mosaic_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'SIM',
                              style: TextStyle(color: Color(0xFF141D32)),
                            ),
                            TextSpan(
                              text: 'APIS',
                              style: TextStyle(color: Color(0xFF5146F5)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'SMP Negeri 1 Lampung',
                        style: TextStyle(fontSize: 11, color: _muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: _muted.withValues(alpha: 0.2)),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
              children: [
                _menuLabel('MENU UTAMA'),
                _menuItem(
                  context,
                  icon: Icons.grid_view_rounded,
                  title: 'Beranda',
                  selected: true,
                  page: const AdminDashboardPage(),
                  isHome: true,
                ),
                _menuItem(
                  context,
                  icon: Icons.people_outline_rounded,
                  title: 'Data Siswa',
                  page: const SiswaPage(),
                ),
                _menuItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'Data Guru',
                  page: const GuruPage(),
                ),
                _menuItem(
                  context,
                  icon: Icons.home_work_outlined,
                  title: 'Data Kelas',
                  page: const KelasPage(),
                ),

                const SizedBox(height: 20),
                _menuLabel('MANAJEMEN'),
                _menuItem(
                  context,
                  icon: Icons.fact_check_outlined,
                  title: 'Input Absensi',
                  page: const AbsensiPage(),
                ),
                _menuItem(
                  context,
                  icon: Icons.error_outline_rounded,
                  title: 'Pelanggaran',
                  page: const PelanggaranPage(),
                ),
                _menuItem(
                  context,
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifikasi Siswa',
                  page: const NotifikasiPage(),
                ),

                const SizedBox(height: 20),
                _menuLabel('LAPORAN'),
                _menuItem(
                  context,
                  icon: Icons.insert_drive_file_outlined,
                  title: 'Laporan Kelas',
                  page: const LaporanPage(),
                ),
                _menuItem(
                  context,
                  icon: Icons.menu_book_outlined,
                  title: 'Tata Tertib',
                  page: const TataTertibPage(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: _muted.withValues(alpha: 0.2)),

          InkWell(
            onTap: () {
              _navigateFromMenu(context, const ProfilPage(role: 'Admin'));
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5146F5), Color(0xFF8585FF)],
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Administrator',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _text,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ADMIN',
                          style: TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: _muted),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 8, 10),
      child: Text(
        title,
        style: TextStyle(
          color: _muted,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
    bool selected = false,
    bool isHome = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? const Color(0xFFEAF2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(icon, color: selected ? _blue : _muted, size: 22),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: selected ? _blue : _text,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          onTap: () {
            if (isHome) {
              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.pop(context);
              }
              return;
            }

            _navigateFromMenu(context, page);
          },
        ),
      ),
    );
  }

  // =========================================================
  // DASHBOARD CONTENT
  // =========================================================

  Widget _buildDashboardContent(
    BuildContext context, {
    required bool isDesktop,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatistics(isDesktop: isDesktop),
          const SizedBox(height: 28),

          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _buildStudentSummary()),
                const SizedBox(width: 24),
                Expanded(
                  flex: 5,
                  child: _buildRecentViolations(context, isDesktop: true),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildStudentSummary(),
                const SizedBox(height: 20),
                _buildRecentViolations(context, isDesktop: false),
              ],
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // =========================================================
  // STATISTICS
  // =========================================================

  Widget _buildStatistics({required bool isDesktop}) {
    final stats = [
      _StatData(
        icon: Icons.people_alt_outlined,
        title: 'Total Siswa',
        value: '320',
        iconColor: const Color(0xFF397CF6),
        iconBackground: const Color(0xFFDCEAFF),
      ),
      _StatData(
        icon: Icons.check_circle_outline_rounded,
        title: 'Hadir Hari Ini',
        value: '295',
        iconColor: const Color(0xFF0AB981),
        iconBackground: const Color(0xFFD0F8E8),
      ),
      _StatData(
        icon: Icons.warning_amber_rounded,
        title: 'Pelanggaran Bulan Ini',
        value: '18',
        iconColor: const Color(0xFFF5A623),
        iconBackground: const Color(0xFFFFF0C2),
      ),
      _StatData(
        icon: Icons.school_outlined,
        title: 'Total Guru',
        value: '35',
        iconColor: const Color(0xFFE56B78),
        iconBackground: const Color(0xFFFFE1E4),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.25 : 1.15,
      ),
      itemBuilder: (context, index) {
        final item = stats[index];

        return Container(
          padding: EdgeInsets.all(isDesktop ? 22 : 15),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD6E5FF)),
            boxShadow: [
              BoxShadow(
                color: _blue.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 25),
              ),
              const Spacer(),
              Text(
                item.value,
                style: TextStyle(
                  color: _text,
                  fontSize: isDesktop ? 32 : 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _muted, fontSize: isDesktop ? 14 : 12),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // STUDENT SUMMARY
  // =========================================================

  Widget _buildStudentSummary() {
    return _panel(
      title: '📊  Ringkasan Data Siswa',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  value: '320',
                  label: 'Total Siswa',
                  color: const Color(0xFF5146F5),
                ),
              ),
              Expanded(
                child: _summaryItem(
                  value: '—',
                  label: 'Laki-laki',
                  color: const Color(0xFF3985F6),
                ),
              ),
              Expanded(
                child: _summaryItem(
                  value: '—',
                  label: 'Perempuan',
                  color: const Color(0xFFF15B5B),
                ),
              ),
              Expanded(
                child: _summaryItem(
                  value: '—',
                  label: 'Kelas Aktif',
                  color: const Color(0xFF0AB981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ringkasan ini akan disesuaikan dengan data '
              'siswa setelah sumber data terhubung.',
              style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RECENT VIOLATIONS
  // =========================================================

  Widget _buildRecentViolations(
    BuildContext context, {
    required bool isDesktop,
  }) {
    return _panel(
      title: '⚠️  Pelanggaran Terbaru',
      action: TextButton(
        onPressed: () {
          _openPage(context, const PelanggaranPage());
        },
        child: const Text(
          'Lihat Semua',
          style: TextStyle(color: _blue, fontWeight: FontWeight.bold),
        ),
      ),
      child: Column(
        children: [
          if (isDesktop) _buildViolationTableHeader(),

          _buildViolationRow(
            name: 'Ahmad Rizky',
            className: 'Kelas VII-A',
            violation: 'Terlambat',
            point: '5',
            date: '2026-05-15',
            isDesktop: isDesktop,
          ),
          _buildViolationRow(
            name: 'Dimas Aditya',
            className: 'Kelas VII-C',
            violation: 'Tidak Seragam',
            point: '10',
            date: '2026-05-14',
            isDesktop: isDesktop,
          ),
          _buildViolationRow(
            name: 'Siti Aulia',
            className: 'Kelas VII-B',
            violation: 'Tidak mengikuti upacara',
            point: '15',
            date: 'Kemarin',
            isDesktop: isDesktop,
          ),
        ],
      ),
    );
  }

  Widget _buildViolationTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F6FF),
        border: Border(bottom: BorderSide(color: Color(0xFFDCE8FC))),
      ),
      child: Row(
        children: [
          _tableHeader('SISWA', 3),
          _tableHeader('PELANGGARAN', 3),
          _tableHeader('POIN', 1),
          _tableHeader('TANGGAL', 2),
        ],
      ),
    );
  }

  Widget _tableHeader(String label, int flex) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: _blue,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildViolationRow({
    required String name,
    required String className,
    required String violation,
    required String point,
    required String date,
    required bool isDesktop,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 8 : 4,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _muted.withValues(alpha: 0.2)),
        ),
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: _text,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          className,
                          style: TextStyle(color: _muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      violation,
                      style: TextStyle(color: _text, fontSize: 11),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: _pointBadge(point)),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      date,
                      style: TextStyle(color: _text, fontSize: 10),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: _text,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    _pointBadge(point),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$className • $violation',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(date, style: TextStyle(color: _muted, fontSize: 11)),
              ],
            ),
    );
  }

  Widget _pointBadge(String point) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD0F8E8),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        point,
        style: const TextStyle(
          color: Color(0xFF087F5B),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // =========================================================
  // REUSABLE PANEL
  // =========================================================

  Widget _panel({
    required String title,
    required Widget child,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD6E5FF)),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: _text,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (action != null) action,
              ],
            ),
          ),
          Divider(height: 1, color: _muted.withValues(alpha: 0.2)),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackground;

  const _StatData({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackground,
  });
}
