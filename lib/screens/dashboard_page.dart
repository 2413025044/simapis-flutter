import 'package:flutter/material.dart';

import 'kirim_kehadiran_page.dart';
import 'notifikasi_page.dart';
import 'pelanggaran_page.dart';
import 'tata_tertib_page.dart';
import 'profil_page.dart';
import 'login_page.dart';

const Color _studentBlue = Color(0xFF2563EB);
const Color _studentCyan = Color(0xFF06B6D4);
const Color _studentInk = Color(0xFF172033);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isDarkMode = false;

  Color get _background =>
      _isDarkMode ? const Color(0xFF101827) : const Color(0xFFF0F6FF);

  Color get _panel => _isDarkMode ? const Color(0xFF1E293B) : Colors.white;

  Color get _text => _isDarkMode ? const Color(0xFFF1F5F9) : _studentInk;

  Color get _muted =>
      _isDarkMode ? const Color(0xFFB0BDD0) : const Color(0xFF91A2BD);

  Color get _border =>
      _isDarkMode ? const Color(0xFF334155) : const Color(0xFFD6E5FF);

  void _openPage(BuildContext context, Widget page) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  void _showNotifications(BuildContext context) {
    _openPage(context, const NotifikasiPage());
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _panel,
        title: Text('Keluar dari akun?', style: TextStyle(color: _text)),
        content: Text(
          'Apakah kamu yakin ingin keluar dari dashboard siswa?',
          style: TextStyle(color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, screen) {
        final desktop = screen.maxWidth >= 950;

        return Theme(
          data: ThemeData(
            brightness: _isDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: _studentBlue,
              brightness: _isDarkMode ? Brightness.dark : Brightness.light,
            ),
            scaffoldBackgroundColor: _background,
            appBarTheme: AppBarTheme(
              backgroundColor: _panel,
              foregroundColor: _text,
            ),
          ),
          child: Scaffold(
            backgroundColor: _background,
            drawer: desktop
                ? null
                : Drawer(
                    backgroundColor: _panel,
                    child: _buildSidebar(context),
                  ),
            appBar: desktop
                ? null
                : AppBar(
                    title: Text(
                      'Dashboard Siswa',
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    actions: _buildHeaderActions(context),
                  ),
            body: desktop
                ? Row(
                    children: [
                      SizedBox(width: 250, child: _buildSidebar(context)),
                      Expanded(
                        child: Column(
                          children: [
                            _buildDesktopHeader(context),
                            Expanded(
                              child: _buildContent(context, desktop: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : _buildContent(context, desktop: false),
          ),
        );
      },
    );
  }

  List<Widget> _buildHeaderActions(BuildContext context) => [
    IconButton(
      tooltip: 'Notifikasi',
      onPressed: () => _showNotifications(context),
      icon: const Icon(Icons.notifications_none_rounded),
    ),
    IconButton(
      tooltip: _isDarkMode ? 'Tema terang' : 'Tema gelap',
      onPressed: _toggleTheme,
      icon: Icon(
        _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
      ),
    ),
    IconButton(
      tooltip: 'Logout',
      onPressed: _confirmLogout,
      icon: const Icon(Icons.logout_rounded),
    ),
    const SizedBox(width: 6),
  ];

  Widget _buildSidebar(BuildContext context) {
    return Container(
      color: _panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _brandHeader(),
          Divider(height: 1, color: _border),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              children: [
                _sidebarLabel('MENU UTAMA'),
                _navItem(Icons.dashboard_outlined, 'Beranda', selected: true),
                _navItem(
                  Icons.edit_note_rounded,
                  'Isi Absensi',
                  onTap: () => _openPage(context, const KirimKehadiranPage()),
                ),
                _navItem(
                  Icons.fact_check_outlined,
                  'Riwayat Absensi',
                  onTap: () => _showHistory(context),
                ),
                _navItem(
                  Icons.error_outline_rounded,
                  'Riwayat Pelanggaran',
                  onTap: () => _openPage(context, const PelanggaranPage()),
                ),
                const SizedBox(height: 18),
                _sidebarLabel('INFORMASI'),
                _navItem(
                  Icons.menu_book_outlined,
                  'Tata Tertib',
                  onTap: () => _openPage(context, const TataTertibPage()),
                ),
                _navItem(
                  Icons.notifications_none_rounded,
                  'Notifikasi Saya',
                  onTap: () => _showNotifications(context),
                ),
                _navItem(
                  Icons.person_outline_rounded,
                  'Profil Saya',
                  onTap: () =>
                      _openPage(context, const ProfilPage(role: 'Siswa')),
                ),
                const SizedBox(height: 8),
                _navItem(Icons.logout_rounded, 'Logout', onTap: _confirmLogout),
                _navItem(
                  _isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  _isDarkMode ? 'Tema Terang' : 'Tema Gelap',
                  onTap: _toggleTheme,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: _border),
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF665AF0),
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Siswa',
                        style: TextStyle(
                          color: _text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'SISWA',
                        style: TextStyle(color: _muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 14, 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_studentBlue, _studentCyan],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.layers_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIMAPIS',
                  style: TextStyle(
                    color: _text,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'SMP Negeri 1 Lampung',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 6, 8, 9),
    child: Text(
      label,
      style: TextStyle(
        color: _muted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    ),
  );

  Widget _navItem(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: selected,
        selectedTileColor: _isDarkMode
            ? const Color(0xFF263B60)
            : const Color(0xFFE6F0FF),
        leading: Icon(icon, color: selected ? _studentBlue : _muted, size: 21),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? _studentBlue : _text,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _panel,
      padding: const EdgeInsets.fromLTRB(28, 18, 20, 17),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: _text,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Selamat datang kembali!',
                  style: TextStyle(color: _muted, fontSize: 14),
                ),
              ],
            ),
          ),
          ..._buildHeaderActions(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required bool desktop}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(desktop ? 28 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStats(),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 760) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAttendanceHistory()),
                        const SizedBox(width: 20),
                        Expanded(child: _buildViolationHistory(context)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildAttendanceHistory(),
                      const SizedBox(height: 18),
                      _buildViolationHistory(context),
                    ],
                  );
                },
              ),
              const SizedBox(height: 22),
              _buildQuickAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    final stats = <_StudentStat>[
      _StudentStat(
        '95%',
        'Persentase Kehadiran',
        Icons.bar_chart_rounded,
        const Color(0xFF2873F0),
        const Color(0xFFDCEBFF),
      ),
      _StudentStat(
        '15',
        'Total Hadir',
        Icons.check_box_rounded,
        const Color(0xFF10B981),
        const Color(0xFFD2F9E8),
      ),
      _StudentStat(
        '1',
        'Total Izin/Sakit',
        Icons.event_busy_rounded,
        const Color(0xFFF59E0B),
        const Color(0xFFFFF0C2),
      ),
      _StudentStat(
        '0',
        'Poin Pelanggaran',
        Icons.warning_amber_rounded,
        const Color(0xFFEF4444),
        const Color(0xFFFFE0E0),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1050 ? 4 : 2;
        const gap = 14.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats
              .map((item) => SizedBox(width: cardWidth, child: _statCard(item)))
              .toList(),
        );
      },
    );
  }

  Widget _statCard(_StudentStat item) {
    return Container(
      constraints: const BoxConstraints(minHeight: 154),
      padding: const EdgeInsets.all(20),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(height: 17),
          Text(
            item.value,
            style: TextStyle(
              color: _text,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            item.label,
            style: TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory() => _tablePanel(
    title: 'Riwayat Absensi Terakhir',
    headers: const ['TANGGAL', 'STATUS', 'KETERANGAN'],
    rows: const [
      ['15 Mei 2026', 'Hadir', '-'],
      ['14 Mei 2026', 'Hadir', '-'],
      ['13 Mei 2026', 'Izin', 'Acara keluarga'],
    ],
    attendance: true,
  );

  Widget _buildViolationHistory(BuildContext context) => _tablePanel(
    title: 'Riwayat Pelanggaran',
    headers: const ['TANGGAL', 'PELANGGARAN', 'POIN'],
    rows: const [
      ['10 Mei 2026', 'Terlambat masuk sekolah', '5'],
    ],
    showAll: () => _openPage(context, const PelanggaranPage()),
  );

  Widget _tablePanel({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    bool attendance = false,
    VoidCallback? showAll,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 10, 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: _text,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (showAll != null)
                  TextButton(
                    onPressed: showAll,
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: _border),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 560,
              child: Column(
                children: [
                  _buildTableHeader(headers),
                  ...rows.map(
                    (row) => _buildTableDataRow(
                      headers: headers,
                      row: row,
                      attendance: attendance,
                    ),
                  ),
                  if (rows.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Tidak ada data lain',
                        style: TextStyle(color: _muted, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> headers) {
    return Container(
      color: _isDarkMode ? const Color(0xFF263449) : const Color(0xFFF7FAFF),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      child: Row(
        children: List.generate(headers.length, (index) {
          return Expanded(
            flex: _columnFlex(headers, index),
            child: Text(
              headers[index],
              style: const TextStyle(
                color: _studentBlue,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTableDataRow({
    required List<String> headers,
    required List<String> row,
    required bool attendance,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        children: List.generate(row.length, (index) {
          Widget value = Text(
            row[index],
            style: TextStyle(color: _text, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );

          if (attendance && index == 1) {
            final present = row[index] == 'Hadir';
            value = Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: present
                      ? const Color(0xFFD2F9E8)
                      : const Color(0xFFDCEBFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  row[index],
                  style: TextStyle(
                    color: present ? const Color(0xFF047857) : _studentBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          }

          if (!attendance && index == 2) {
            value = Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD2F9E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  row[index],
                  style: const TextStyle(
                    color: Color(0xFF047857),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          }

          return Expanded(
            flex: _columnFlex(headers, index),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: value,
            ),
          );
        }),
      ),
    );
  }

  int _columnFlex(List<String> headers, int index) {
    if (headers.length == 3 && headers[0] == 'TANGGAL') {
      if (headers[1] == 'STATUS') {
        return index == 0 ? 11 : (index == 1 ? 8 : 12);
      }
      return index == 0 ? 10 : (index == 1 ? 16 : 5);
    }
    return 10;
  }

  Widget _buildQuickAction(BuildContext context) {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openPage(context, const KirimKehadiranPage()),
              style: FilledButton.styleFrom(
                backgroundColor: _studentBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text(
                'Lapor Kehadiran Hari Ini',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() => BoxDecoration(
    color: _panel,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _border),
    boxShadow: _isDarkMode
        ? []
        : [
            BoxShadow(
              color: const Color(0xFF2B64B7).withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
  );

  void _showHistory(BuildContext context) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: _panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Riwayat Absensi',
              style: TextStyle(
                color: _text,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Angka ini masih berupa data contoh dan belum terhubung ke database.',
              style: TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            _historyLine('Hadir', '15 hari', const Color(0xFF10B981)),
            _historyLine('Izin', '1 hari', _studentBlue),
            _historyLine('Sakit', '0 hari', const Color(0xFFF59E0B)),
            _historyLine('Alfa', '0 hari', const Color(0xFFEF4444)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyLine(String label, String value, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: TextStyle(color: _text)),
        ),
        Text(
          value,
          style: TextStyle(color: _text, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

class _StudentStat {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color background;

  const _StudentStat(
    this.value,
    this.label,
    this.icon,
    this.color,
    this.background,
  );
}
