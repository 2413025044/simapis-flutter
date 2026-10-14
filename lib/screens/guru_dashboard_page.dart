import 'package:flutter/material.dart';

import 'absensi_page.dart';
import 'pelanggaran_page.dart';
import 'notifikasi_page.dart';
import 'laporan_page.dart';
import 'tata_tertib_page.dart';
import 'profil_page.dart';

const Color _guruBlue = Color(0xFF2563EB);
const Color _guruCyan = Color(0xFF06B6D4);
const Color _guruInk = Color(0xFF172033);
const Color _guruBackground = Color(0xFFF0F6FF);

class GuruDashboardPage extends StatelessWidget {
  const GuruDashboardPage({super.key});

  void _openPage(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      navigator.pop();
    }
    navigator.push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, screen) {
        final desktop = screen.maxWidth >= 950;
        return Scaffold(
          backgroundColor: _guruBackground,
          drawer: desktop
              ? null
              : Drawer(
                  child: Builder(
                    builder: (drawerContext) => _buildSidebar(drawerContext),
                  ),
                ),
          appBar: desktop
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: _guruInk,
                  elevation: 0,
                  title: const Text(
                    'Dashboard Guru',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
          body: desktop
              ? Row(
                  children: [
                    SizedBox(width: 250, child: _buildSidebar(context)),
                    Expanded(
                      child: Column(
                        children: [
                          _buildDesktopHeader(),
                          Expanded(
                            child: _buildContent(context, desktop: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : _buildContent(context, desktop: false),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FBFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 14, 20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_guruBlue, _guruCyan],
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIMAPIS',
                        style: TextStyle(
                          color: _guruInk,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'SMP Negeri 1 Lampung',
                        style: TextStyle(
                          color: Color(0xFF91A2BD),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFDCE8FA)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              children: [
                _label('MENU UTAMA'),
                _nav(
                  context,
                  Icons.dashboard_outlined,
                  'Beranda',
                  null,
                  selected: true,
                ),
                _nav(
                  context,
                  Icons.fact_check_outlined,
                  'Input Absensi',
                  const AbsensiPage(),
                ),
                _nav(
                  context,
                  Icons.error_outline_rounded,
                  'Input Pelanggaran',
                  const PelanggaranPage(),
                ),
                _nav(
                  context,
                  Icons.notifications_none_rounded,
                  'Notifikasi Siswa',
                  const NotifikasiPage(),
                ),
                const SizedBox(height: 18),
                _label('LAPORAN'),
                _nav(
                  context,
                  Icons.description_outlined,
                  'Laporan Absensi',
                  const LaporanPage(),
                ),
                _nav(
                  context,
                  Icons.menu_book_outlined,
                  'Tata Tertib',
                  const TataTertibPage(),
                ),
                const SizedBox(height: 18),
                _label('LAINNYA'),
                _nav(
                  context,
                  Icons.settings_outlined,
                  'Pengaturan',
                  const ProfilPage(role: 'Guru'),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFDCE8FA)),
          InkWell(
            onTap: () => _openPage(context, const ProfilPage(role: 'Guru')),
            child: Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFDCE8FA)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF665AF0),
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guru',
                          style: TextStyle(
                            color: _guruInk,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'GURU',
                          style: TextStyle(
                            color: Color(0xFF91A2BD),
                            fontSize: 11,
                          ),
                        ),
                      ],
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

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 6, 8, 9),
    child: Text(
      value,
      style: const TextStyle(
        color: Color(0xFF91A2BD),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    ),
  );

  Widget _nav(
    BuildContext context,
    IconData icon,
    String title,
    Widget? page, {
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: selected,
        selectedTileColor: const Color(0xFFE6F0FF),
        leading: Icon(
          icon,
          color: selected ? _guruBlue : const Color(0xFF647895),
          size: 21,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? _guruBlue : const Color(0xFF5F718E),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        onTap: () {
          if (page == null) {
            if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
              Navigator.of(context).pop();
            }
            return;
          }
          _openPage(context, page);
        },
      ),
    );
  }

  Widget _buildDesktopHeader() => Container(
    color: Colors.white,
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(28, 18, 28, 17),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            color: _guruInk,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Selamat datang kembali!',
          style: TextStyle(color: Color(0xFF91A2BD), fontSize: 14),
        ),
      ],
    ),
  );

  Widget _buildContent(BuildContext context, {required bool desktop}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(desktop ? 28 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStats(constraints.maxWidth),
                  const SizedBox(height: 22),
                  if (constraints.maxWidth >= 760)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _classAttendance()),
                        const SizedBox(width: 20),
                        Expanded(child: _quickActions(context)),
                      ],
                    )
                  else ...[
                    _classAttendance(),
                    const SizedBox(height: 18),
                    _quickActions(context),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStats(double width) {
    final stats = <_TeacherStat>[
      _TeacherStat(
        '0',
        'Siswa Kelas Anda',
        Icons.assignment_outlined,
        const Color(0xFF2873F0),
        const Color(0xFFDCEBFF),
      ),
      _TeacherStat(
        '0',
        'Hadir Hari Ini',
        Icons.check_box_rounded,
        const Color(0xFF10B981),
        const Color(0xFFD2F9E8),
      ),
      _TeacherStat(
        '0',
        'Belum Absen',
        Icons.edit_note_rounded,
        const Color(0xFFF59E0B),
        const Color(0xFFFFF0C2),
      ),
      _TeacherStat(
        '0',
        'Pelanggaran Bulan Ini',
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

  Widget _statCard(_TeacherStat item) => Container(
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
          style: const TextStyle(
            color: _guruInk,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          item.label,
          style: const TextStyle(
            color: Color(0xFF91A2BD),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _classAttendance() => Container(
    clipBehavior: Clip.antiAlias,
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            '📊  Kehadiran Kelas Hari Ini',
            style: TextStyle(
              color: _guruInk,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFDCE8FA)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  _attendanceNumber('28', 'Hadir', const Color(0xFF10B981)),
                  _attendanceNumber('1', 'Izin', _guruBlue),
                  _attendanceNumber('1', 'Sakit', const Color(0xFFF59E0B)),
                  _attendanceNumber('2', 'Alpha', const Color(0xFFEF4444)),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  value: 0.875,
                  minHeight: 12,
                  backgroundColor: Color(0xFFFFE0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                ),
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ringkasan contoh kehadiran kelas.',
                  style: TextStyle(color: Color(0xFF91A2BD), fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _attendanceNumber(String value, String label, Color color) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF91A2BD), fontSize: 11),
        ),
      ],
    ),
  );

  Widget _quickActions(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: _panelDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            '⚡  Aksi Cepat',
            style: TextStyle(
              color: _guruInk,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFDCE8FA)),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _actionButton(
                context,
                'Input Absensi Hari Ini',
                Icons.edit_note_rounded,
                const Color(0xFF2873F0),
                const AbsensiPage(),
              ),
              const SizedBox(height: 12),
              _actionButton(
                context,
                'Input Pelanggaran Siswa',
                Icons.warning_amber_rounded,
                const Color(0xFFF59E0B),
                const PelanggaranPage(),
              ),
              const SizedBox(height: 12),
              _actionButton(
                context,
                'Lihat Laporan Kelas',
                Icons.bar_chart_rounded,
                null,
                const LaporanPage(),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _actionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color? color,
    Widget page,
  ) {
    if (color == null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _openPage(context, page),
          icon: Icon(icon, color: const Color(0xFF647895)),
          label: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF647895),
              fontWeight: FontWeight.w800,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: const BorderSide(color: Color(0xFFD6E5FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _openPage(context, page),
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  BoxDecoration _panelDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFD6E5FF)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF2B64B7).withValues(alpha: 0.04),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

class _TeacherStat {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  const _TeacherStat(
    this.value,
    this.label,
    this.icon,
    this.color,
    this.background,
  );
}
