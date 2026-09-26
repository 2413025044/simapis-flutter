import 'package:flutter/material.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String _selectedKelas = 'VII A';
  String _selectedPeriode = 'September 2026';

  final List<String> _kelasList = [
    'VII A',
    'VII B',
    'VIII A',
    'VIII B',
    'IX A',
  ];

  final List<String> _periodeList = [
    'September 2026',
    'Agustus 2026',
    'Juli 2026',
  ];

  // Data dummy laporan
  final Map<String, Map<String, dynamic>> _laporanData = {
    'VII A': {
      'wali': 'Budi Santoso',
      'jumlahSiswa': 32,
      'hadir': 285,
      'izin': 12,
      'sakit': 8,
      'alpa': 3,
      'terlambat': 15,
      'pelanggaran': 8,
      'poin': 65,
    },
    'VII B': {
      'wali': 'Siti Rahmawati',
      'jumlahSiswa': 30,
      'hadir': 270,
      'izin': 10,
      'sakit': 7,
      'alpa': 5,
      'terlambat': 18,
      'pelanggaran': 10,
      'poin': 80,
    },
    'VIII A': {
      'wali': 'Andi Wijaya',
      'jumlahSiswa': 31,
      'hadir': 290,
      'izin': 9,
      'sakit': 6,
      'alpa': 2,
      'terlambat': 13,
      'pelanggaran': 6,
      'poin': 45,
    },
    'VIII B': {
      'wali': 'Dewi Lestari',
      'jumlahSiswa': 29,
      'hadir': 260,
      'izin': 14,
      'sakit': 9,
      'alpa': 4,
      'terlambat': 20,
      'pelanggaran': 9,
      'poin': 75,
    },
    'IX A': {
      'wali': 'Rudi Hartono',
      'jumlahSiswa': 28,
      'hadir': 275,
      'izin': 8,
      'sakit': 5,
      'alpa': 2,
      'terlambat': 11,
      'pelanggaran': 5,
      'poin': 40,
    },
  };

  Map<String, dynamic> get _data {
    return _laporanData[_selectedKelas]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Laporan Kelas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: _printReport,
          ),
        ],
      ),

      body: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              children: [
                _buildClassInfo(),
                const SizedBox(height: 16),
                _buildAttendanceSummary(),
                const SizedBox(height: 16),
                _buildAttendanceDetail(),
                const SizedBox(height: 16),
                _buildViolationSummary(),
                const SizedBox(height: 16),
                _buildPercentageCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dropdown(
                  value: _selectedKelas,
                  items: _kelasList,
                  label: 'Kelas',
                  icon: Icons.class_outlined,
                  onChanged: (value) {
                    setState(() {
                      _selectedKelas = value!;
                    });
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _dropdown(
                  value: _selectedPeriode,
                  items: _periodeList,
                  label: 'Periode',
                  icon: Icons.calendar_month_outlined,
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriode = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DROPDOWN
  // =========================================================

  Widget _dropdown({
    required String value,
    required List<String> items,
    required String label,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1565C0)),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 17, color: const Color(0xFF1565C0)),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // =========================================================
  // INFO KELAS
  // =========================================================

  Widget _buildClassInfo() {
    return _sectionCard(
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              color: Color(0xFF1565C0),
              size: 29,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kelas $_selectedKelas',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Wali Kelas: ${_data['wali']}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_data['jumlahSiswa']} siswa',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RINGKASAN ABSENSI
  // =========================================================

  Widget _buildAttendanceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Ringkasan Absensi', Icons.fact_check_outlined),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Hadir',
                value: '${_data['hadir']}',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _summaryCard(
                title: 'Izin',
                value: '${_data['izin']}',
                icon: Icons.assignment_outlined,
                color: Colors.orange,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Sakit',
                value: '${_data['sakit']}',
                icon: Icons.sick_outlined,
                color: Colors.blue,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _summaryCard(
                title: 'Alpa',
                value: '${_data['alpa']}',
                icon: Icons.cancel_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // DETAIL ABSENSI
  // =========================================================

  Widget _buildAttendanceDetail() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Detail Kehadiran', Icons.bar_chart_outlined),

          const SizedBox(height: 18),

          _progressItem(
            label: 'Hadir',
            value: _data['hadir'],
            color: Colors.green,
            total: _totalAttendance,
          ),

          const SizedBox(height: 14),

          _progressItem(
            label: 'Izin',
            value: _data['izin'],
            color: Colors.orange,
            total: _totalAttendance,
          ),

          const SizedBox(height: 14),

          _progressItem(
            label: 'Sakit',
            value: _data['sakit'],
            color: Colors.blue,
            total: _totalAttendance,
          ),

          const SizedBox(height: 14),

          _progressItem(
            label: 'Alpa',
            value: _data['alpa'],
            color: Colors.red,
            total: _totalAttendance,
          ),

          const SizedBox(height: 14),

          _progressItem(
            label: 'Terlambat',
            value: _data['terlambat'],
            color: Colors.purple,
            total: _totalAttendance,
          ),
        ],
      ),
    );
  }

  int get _totalAttendance {
    return (_data['hadir'] as int) +
        (_data['izin'] as int) +
        (_data['sakit'] as int) +
        (_data['alpa'] as int) +
        (_data['terlambat'] as int);
  }

  // =========================================================
  // PROGRESS
  // =========================================================

  Widget _progressItem({
    required String label,
    required int value,
    required Color color,
    required int total,
  }) {
    final percentage = total == 0 ? 0.0 : value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$value',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 7),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PELANGGARAN
  // =========================================================

  Widget _buildViolationSummary() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Pelanggaran Siswa', Icons.warning_amber_outlined),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _violationInfo(
                  icon: Icons.warning_amber_rounded,
                  title: 'Pelanggaran',
                  value: '${_data['pelanggaran']}',
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _violationInfo(
                  icon: Icons.stars_outlined,
                  title: 'Total Poin',
                  value: '${_data['poin']}',
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 20),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Data pelanggaran menampilkan jumlah kejadian dan total poin pelanggaran siswa selama periode $_selectedPeriode.',
                    style: const TextStyle(fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PERSENTASE
  // =========================================================

  Widget _buildPercentageCard() {
    final total = _totalAttendance;

    final hadirPercentage = total == 0
        ? 0
        : ((_data['hadir'] as int) / total * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.trending_up, color: Colors.white, size: 32),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Persentase Kehadiran',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),

                const SizedBox(height: 4),

                Text(
                  '$hadirPercentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Kelas $_selectedKelas • $_selectedPeriode',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY CARD
  // =========================================================

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // VIOLATION INFO
  // =========================================================

  Widget _violationInfo({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
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

  // =========================================================
  // SECTION CARD
  // =========================================================

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 22),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // =========================================================
  // PRINT / CETAK
  // =========================================================

  void _printReport() {
    _showMessage('Fitur cetak laporan akan dihubungkan pada tahap berikutnya.');
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
