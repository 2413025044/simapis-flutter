import 'package:flutter/material.dart';

class PelanggaranPage extends StatefulWidget {
  const PelanggaranPage({super.key});

  @override
  State<PelanggaranPage> createState() => _PelanggaranPageState();
}

class _PelanggaranPageState extends State<PelanggaranPage> {
  // =========================================================
  // DATA DUMMY PELANGGARAN
  // =========================================================

  final List<Map<String, dynamic>> _pelanggaran = [
    {
      'nama': 'Ahmad Rizky',
      'nis': '24001',
      'kelas': 'VII A',
      'jenis': 'Tidak menggunakan atribut lengkap',
      'poin': 5,
      'tanggal': '26 September 2026',
      'keterangan': 'Siswa tidak menggunakan dasi sekolah.',
    },
    {
      'nama': 'Siti Aulia',
      'nis': '24002',
      'kelas': 'VII A',
      'jenis': 'Terlambat masuk sekolah',
      'poin': 10,
      'tanggal': '26 September 2026',
      'keterangan': 'Siswa datang terlambat 20 menit.',
    },
    {
      'nama': 'Budi Pratama',
      'nis': '24003',
      'kelas': 'VII B',
      'jenis': 'Tidak mengerjakan tugas',
      'poin': 15,
      'tanggal': '25 September 2026',
      'keterangan': 'Tugas mata pelajaran Informatika tidak dikumpulkan.',
    },
    {
      'nama': 'Dewi Lestari',
      'nis': '24004',
      'kelas': 'VIII A',
      'jenis': 'Rambut tidak sesuai aturan',
      'poin': 10,
      'tanggal': '24 September 2026',
      'keterangan': 'Rambut siswa melebihi ketentuan tata tertib.',
    },
    {
      'nama': 'Rizky Maulana',
      'nis': '24005',
      'kelas': 'VIII B',
      'jenis': 'Membawa barang terlarang',
      'poin': 50,
      'tanggal': '23 September 2026',
      'keterangan':
          'Membawa barang yang tidak diperbolehkan di lingkungan sekolah.',
    },
    {
      'nama': 'Fajar Nugraha',
      'nis': '24006',
      'kelas': 'IX A',
      'jenis': 'Bolos sekolah',
      'poin': 75,
      'tanggal': '22 September 2026',
      'keterangan': 'Tidak mengikuti kegiatan pembelajaran tanpa keterangan.',
    },
  ];

  // =========================================================
  // CONTROLLER
  // =========================================================

  final TextEditingController _searchController = TextEditingController();

  String _selectedKelas = 'Semua Kelas';
  String _selectedJenis = 'Semua Jenis';

  // =========================================================
  // DAFTAR FILTER
  // =========================================================

  final List<String> _kelasList = [
    'Semua Kelas',
    'VII A',
    'VII B',
    'VIII A',
    'VIII B',
    'IX A',
  ];

  final List<String> _jenisList = [
    'Semua Jenis',
    'Tidak menggunakan atribut lengkap',
    'Terlambat masuk sekolah',
    'Tidak mengerjakan tugas',
    'Rambut tidak sesuai aturan',
    'Membawa barang terlarang',
    'Bolos sekolah',
  ];

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // FILTER DATA
  // =========================================================

  List<Map<String, dynamic>> get _filteredData {
    final keyword = _searchController.text.toLowerCase();

    return _pelanggaran.where((item) {
      final cocokSearch =
          item['nama'].toString().toLowerCase().contains(keyword) ||
          item['nis'].toString().toLowerCase().contains(keyword) ||
          item['jenis'].toString().toLowerCase().contains(keyword);

      final cocokKelas =
          _selectedKelas == 'Semua Kelas' || item['kelas'] == _selectedKelas;

      final cocokJenis =
          _selectedJenis == 'Semua Jenis' || item['jenis'] == _selectedJenis;

      return cocokSearch && cocokKelas && cocokJenis;
    }).toList();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'Pelanggaran Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              _showMessage('Belum ada notifikasi baru');
            },
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: _filteredData.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];

                      return _buildViolationCard(
                        item: item,
                        originalIndex: _pelanggaran.indexOf(item),
                      );
                    },
                  ),
          ),
        ],
      ),

      // =====================================================
      // FLOATING BUTTON
      // =====================================================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: () {
          _showPelanggaranForm();
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    final totalPoin = _pelanggaran.fold<int>(
      0,
      (sum, item) => sum + (item['poin'] as int),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  icon: Icons.warning_amber_rounded,
                  title: 'Pelanggaran',
                  value: '${_pelanggaran.length}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryCard(
                  icon: Icons.stars_rounded,
                  title: 'Total Poin',
                  value: '$totalPoin',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // SEARCH
          TextField(
            controller: _searchController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Cari nama, NIS, atau pelanggaran...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // FILTER
          Row(
            children: [
              Expanded(
                child: _filterDropdown(
                  value: _selectedKelas,
                  items: _kelasList,
                  icon: Icons.class_outlined,
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedKelas = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _filterDropdown(
                  value: _selectedJenis,
                  items: _jenisList,
                  icon: Icons.filter_alt_outlined,
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedJenis = value;
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
  // SUMMARY CARD
  // =========================================================

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
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
  // FILTER DROPDOWN
  // =========================================================

  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
  // VIOLATION CARD
  // =========================================================

  Widget _buildViolationCard({
    required Map<String, dynamic> item,
    required int originalIndex,
  }) {
    final poin = item['poin'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ICON
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getPoinColor(poin).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: _getPoinColor(poin),
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                // NAMA SISWA
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIS ${item['nis']} • ${item['kelas']}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // POIN
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getPoinColor(poin).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$poin poin',
                    style: TextStyle(
                      color: _getPoinColor(poin),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // JENIS PELANGGARAN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.report_problem_outlined,
                    size: 19,
                    color: Color(0xFF1565C0),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      item['jenis'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  item['tanggal'].toString(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const Spacer(),

                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'detail') {
                      _showDetail(item);
                    } else if (value == 'edit') {
                      _showPelanggaranForm(editIndex: originalIndex);
                    } else if (value == 'delete') {
                      _deletePelanggaran(originalIndex);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'detail',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined),
                          SizedBox(width: 10),
                          Text('Lihat Detail'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Hapus'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // WARNA POIN
  // =========================================================

  Color _getPoinColor(int poin) {
    if (poin >= 50) {
      return Colors.red;
    } else if (poin >= 15) {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 15),
            const Text(
              'Data tidak ditemukan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah kata pencarian atau filter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DETAIL
  // =========================================================

  void _showDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Detail Pelanggaran',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              _detailRow(
                Icons.person_outline,
                'Nama Siswa',
                item['nama'].toString(),
              ),

              _detailRow(Icons.badge_outlined, 'NIS', item['nis'].toString()),

              _detailRow(
                Icons.class_outlined,
                'Kelas',
                item['kelas'].toString(),
              ),

              _detailRow(
                Icons.warning_amber_outlined,
                'Jenis Pelanggaran',
                item['jenis'].toString(),
              ),

              _detailRow(Icons.stars_outlined, 'Poin', '${item['poin']} poin'),

              _detailRow(
                Icons.calendar_today_outlined,
                'Tanggal',
                item['tanggal'].toString(),
              ),

              _detailRow(
                Icons.notes_outlined,
                'Keterangan',
                item['keterangan'].toString(),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // DETAIL ROW
  // =========================================================

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1565C0), size: 21),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FORM TAMBAH / EDIT
  // =========================================================

  void _showPelanggaranForm({int? editIndex}) {
    final bool isEdit = editIndex != null;

    Map<String, dynamic>? item;

    if (isEdit) {
      item = _pelanggaran[editIndex];
    }

    final namaController = TextEditingController(
      text: item?['nama']?.toString() ?? '',
    );

    final nisController = TextEditingController(
      text: item?['nis']?.toString() ?? '',
    );

    final keteranganController = TextEditingController(
      text: item?['keterangan']?.toString() ?? '',
    );

    String selectedKelas = item?['kelas']?.toString() ?? 'VII A';

    String selectedJenis = item?['jenis']?.toString() ?? _jenisList[1];

    int selectedPoin = item?['poin'] as int? ?? 10;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      isEdit ? 'Edit Pelanggaran' : 'Tambah Pelanggaran',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _formField(
                      controller: namaController,
                      label: 'Nama Siswa',
                      hint: 'Masukkan nama siswa',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 14),

                    _formField(
                      controller: nisController,
                      label: 'NIS',
                      hint: 'Masukkan NIS siswa',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 14),

                    _formDropdown(
                      value: selectedKelas,
                      label: 'Kelas',
                      icon: Icons.class_outlined,
                      items: _kelasList
                          .where((e) => e != 'Semua Kelas')
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setModalState(() {
                          selectedKelas = value;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _formDropdown(
                      value: selectedJenis,
                      label: 'Jenis Pelanggaran',
                      icon: Icons.warning_amber_outlined,
                      items: _jenisList
                          .where((e) => e != 'Semua Jenis')
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setModalState(() {
                          selectedJenis = value;

                          // POIN OTOMATIS
                          if (selectedJenis ==
                              'Tidak menggunakan atribut lengkap') {
                            selectedPoin = 5;
                          } else if (selectedJenis ==
                              'Terlambat masuk sekolah') {
                            selectedPoin = 10;
                          } else if (selectedJenis ==
                              'Tidak mengerjakan tugas') {
                            selectedPoin = 15;
                          } else if (selectedJenis ==
                              'Rambut tidak sesuai aturan') {
                            selectedPoin = 10;
                          } else if (selectedJenis ==
                              'Membawa barang terlarang') {
                            selectedPoin = 50;
                          } else if (selectedJenis == 'Bolos sekolah') {
                            selectedPoin = 75;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    // POIN
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.stars_outlined,
                            color: Color(0xFF1565C0),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Poin Pelanggaran',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getPoinColor(selectedPoin)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$selectedPoin poin',
                              style: TextStyle(
                                color: _getPoinColor(selectedPoin),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _formField(
                      controller: keteranganController,
                      label: 'Keterangan',
                      hint: 'Masukkan keterangan pelanggaran',
                      icon: Icons.notes_outlined,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (namaController.text.trim().isEmpty ||
                                  nisController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Nama siswa dan NIS wajib diisi.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final String tanggal = isEdit && item != null
                                  ? item['tanggal'].toString()
                                  : '26 September 2026';

                              final data = {
                                'nama': namaController.text.trim(),
                                'nis': nisController.text.trim(),
                                'kelas': selectedKelas,
                                'jenis': selectedJenis,
                                'poin': selectedPoin,
                                'tanggal': tanggal,
                                'keterangan':
                                    keteranganController.text.trim().isEmpty
                                    ? '-'
                                    : keteranganController.text.trim(),
                              };

                              setState(() {
                                if (isEdit && editIndex != null) {
                                  _pelanggaran[editIndex] = data;
                                } else {
                                  _pelanggaran.insert(0, data);
                                }
                              });

                              Navigator.pop(context);

                              _showMessage(
                                isEdit
                                    ? 'Pelanggaran berhasil diperbarui'
                                    : 'Pelanggaran berhasil ditambahkan',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(isEdit ? 'Simpan' : 'Tambah'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // FORM FIELD
  // =========================================================

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // =========================================================
  // FORM DROPDOWN
  // =========================================================

  Widget _formDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // =========================================================
  // DELETE
  // =========================================================

  void _deletePelanggaran(int index) {
    final item = _pelanggaran[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pelanggaran?'),
          content: Text('Data pelanggaran ${item['nama']} akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pelanggaran.removeAt(index);
                });

                Navigator.pop(context);

                _showMessage('Data pelanggaran berhasil dihapus');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
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
