import 'package:flutter/material.dart';

import 'kirim_kehadiran_page.dart';
import 'notifikasi_page.dart';
import 'pelanggaran_page.dart';
import 'tata_tertib_page.dart';
import 'profil_page.dart';

const Color _studentBlue = Color(0xFF2563EB);
const Color _studentCyan = Color(0xFF06B6D4);
const Color _studentInk = Color(0xFF172033);
const Color _studentBackground = Color(0xFFF0F6FF);

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
        final bool desktop = screen.maxWidth >= 950;
        return Scaffold(
          backgroundColor: _studentBackground,
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
                  foregroundColor: _studentInk,
                  elevation: 0,
                  title: const Text(
                    'Dashboard Siswa',
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
          _brandHeader(),
          const Divider(height: 1, color: Color(0xFFDCE8FA)),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              children: [
                _sidebarLabel('MENU UTAMA'),
                _navItem(
                  context,
                  Icons.dashboard_outlined,
                  'Beranda',
                  selected: true,
                ),
                _navItem(
                  context,
                  Icons.edit_note_rounded,
                  'Isi Absensi',
                  onTap: () => _openPage(context, const KirimKehadiranPage()),
                ),
                _navItem(
                  context,
                  Icons.fact_check_outlined,
                  'Riwayat Absensi',
                  onTap: () => _showHistory(context),
                ),
                _navItem(
                  context,
                  Icons.error_outline_rounded,
                  'Riwayat Pelanggaran',
                  onTap: () => _openPage(context, const PelanggaranPage()),
                ),
                const SizedBox(height: 18),
                _sidebarLabel('INFORMASI'),
                _navItem(
                  context,
                  Icons.menu_book_outlined,
                  'Tata Tertib',
                  onTap: () => _openPage(context, const TataTertibPage()),
                ),
                _navItem(
                  context,
                  Icons.notifications_none_rounded,
                  'Notifikasi Saya',
                  onTap: () => _openPage(context, const NotifikasiPage()),
                ),
                _navItem(
                  context,
                  Icons.person_outline_rounded,
                  'Profil Saya',
                  onTap: () =>
                      _openPage(context, const ProfilPage(role: 'Siswa')),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFDCE8FA)),
          InkWell(
            onTap: () => _openPage(context, const ProfilPage(role: 'Siswa')),
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
                      'S',
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
                          'Siswa',
                          style: TextStyle(
                            color: _studentInk,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'SISWA',
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIMAPIS',
                  style: TextStyle(
                    color: _studentInk,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'SMP Negeri 1 Lampung',
                  style: TextStyle(color: Color(0xFF91A2BD), fontSize: 11),
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
      style: const TextStyle(
        color: Color(0xFF91A2BD),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    ),
  );

  Widget _navItem(
    BuildContext context,
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
        selectedTileColor: const Color(0xFFE6F0FF),
        leading: Icon(
          icon,
          color: selected ? _studentBlue : const Color(0xFF647895),
          size: 21,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? _studentBlue : const Color(0xFF5F718E),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
        onTap:
            onTap ??
            () {
              if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                Navigator.of(context).pop();
              }
            },
      ),
    );
  }

  Widget _buildDesktopHeader() => Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(28, 18, 28, 17),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            color: _studentInk,
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
        final contentWidth = constraints.maxWidth;
        return SingleChildScrollView(
          padding: EdgeInsets.all(desktop ? 28 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStats(contentWidth),
                  const SizedBox(height: 22),
                  if (contentWidth >= 760)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAttendanceHistory()),
                        const SizedBox(width: 20),
                        Expanded(child: _buildViolationHistory(context)),
                      ],
                    )
                  else ...[
                    _buildAttendanceHistory(),
                    const SizedBox(height: 18),
                    _buildViolationHistory(context),
                  ],
                  const SizedBox(height: 22),
                  _buildQuickAction(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStats(double width) {
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

  Widget _statCard(_StudentStat item) => Container(
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
            color: _studentInk,
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

  Widget _buildAttendanceHistory() => _tablePanel(
    title: '📋  Riwayat Absensi Terakhir',
    headers: const ['TANGGAL', 'STATUS', 'KETERANGAN'],
    rows: const [
      ['15 Mei 2026', 'Hadir', '-'],
      ['14 Mei 2026', 'Hadir', '-'],
      ['13 Mei 2026', 'Izin', 'Acara keluarga'],
    ],
    attendance: true,
  );

  Widget _buildViolationHistory(BuildContext context) => _tablePanel(
    title: '⚠️  Riwayat Pelanggaran',
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
                    style: const TextStyle(
                      color: _studentInk,
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
          const Divider(height: 1, color: Color(0xFFDCE8FA)),
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
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Tidak ada data lain',
                        style: TextStyle(
                          color: Color(0xFF91A2BD),
                          fontSize: 12,
                        ),
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
      color: const Color(0xFFF7FAFF),
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
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFDCE8FA))),
      ),
      child: Row(
        children: List.generate(row.length, (index) {
          Widget value = Text(
            row[index],
            style: const TextStyle(color: Color(0xFF334155), fontSize: 11),
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
      if (headers[1] == 'STATUS')
        return index == 0 ? 11 : (index == 1 ? 8 : 12);
      return index == 0 ? 10 : (index == 1 ? 16 : 5);
    }
    return 10;
  }

  Widget _buildQuickAction(BuildContext context) => Container(
    decoration: _panelDecoration(),
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚡  Aksi Cepat',
          style: TextStyle(
            color: _studentInk,
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

  void _showHistory(BuildContext context) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false)
      Navigator.pop(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Riwayat Absensi',
              style: TextStyle(
                color: _studentInk,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Angka ini masih berupa data contoh dan belum terhubung ke database.',
              style: TextStyle(color: Color(0xFF91A2BD), fontSize: 12),
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
          child: Text(label, style: const TextStyle(color: _studentInk)),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _studentInk,
            fontWeight: FontWeight.bold,
          ),
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
