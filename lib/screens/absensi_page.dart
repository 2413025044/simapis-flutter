import 'package:flutter/material.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  String selectedKelas = 'Semua Kelas';
  String selectedStatus = 'Semua Status';

  final List<Map<String, dynamic>> _absensi = [
    {
      'nama': 'Ahmad Rizky',
      'nis': '24001',
      'kelas': 'VII A',
      'jam': '07:12',
      'status': 'Hadir',
    },
    {
      'nama': 'Siti Aulia',
      'nis': '24002',
      'kelas': 'VII A',
      'jam': '07:18',
      'status': 'Hadir',
    },
    {
      'nama': 'Budi Pratama',
      'nis': '24003',
      'kelas': 'VII B',
      'jam': '07:45',
      'status': 'Terlambat',
    },
    {
      'nama': 'Dewi Lestari',
      'nis': '24004',
      'kelas': 'VIII A',
      'jam': '-',
      'status': 'Izin',
    },
    {
      'nama': 'Rizky Maulana',
      'nis': '24005',
      'kelas': 'VIII B',
      'jam': '-',
      'status': 'Sakit',
    },
    {
      'nama': 'Fajar Nugraha',
      'nis': '24006',
      'kelas': 'IX A',
      'jam': '-',
      'status': 'Alpa',
    },
  ];

  List<Map<String, dynamic>> get filteredAbsensi {
    return _absensi.where((item) {
      final cocokKelas =
          selectedKelas == 'Semua Kelas' || item['kelas'] == selectedKelas;

      final cocokStatus =
          selectedStatus == 'Semua Status' || item['status'] == selectedStatus;

      return cocokKelas && cocokStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Data Absensi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSummary(),
          _buildFilter(),
          Expanded(
            child: filteredAbsensi.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada data absensi',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    itemCount: filteredAbsensi.length,
                    itemBuilder: (context, index) {
                      return _buildAbsensiCard(filteredAbsensi[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahAbsensi,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // =========================================================
  // SUMMARY
  // =========================================================

  Widget _buildSummary() {
    final hadir = _absensi.where((item) => item['status'] == 'Hadir').length;

    final terlambat = _absensi
        .where((item) => item['status'] == 'Terlambat')
        .length;

    final izin = _absensi.where((item) => item['status'] == 'Izin').length;

    final sakit = _absensi.where((item) => item['status'] == 'Sakit').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem('Hadir', hadir.toString(), Icons.check_circle),
          ),
          Expanded(
            child: _summaryItem(
              'Terlambat',
              terlambat.toString(),
              Icons.access_time,
            ),
          ),
          Expanded(
            child: _summaryItem('Izin', izin.toString(), Icons.assignment),
          ),
          Expanded(child: _summaryItem('Sakit', sakit.toString(), Icons.sick)),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }

  // =========================================================
  // FILTER
  // =========================================================

  Widget _buildFilter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _dropdown(
              value: selectedKelas,
              label: 'Kelas',
              items: const [
                'Semua Kelas',
                'VII A',
                'VII B',
                'VIII A',
                'VIII B',
                'IX A',
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedKelas = value;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _dropdown(
              value: selectedStatus,
              label: 'Status',
              items: const [
                'Semua Status',
                'Hadir',
                'Terlambat',
                'Izin',
                'Sakit',
                'Alpa',
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedStatus = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // =========================================================
  // ABSENSI CARD
  // =========================================================

  Widget _buildAbsensiCard(Map<String, dynamic> item) {
    final status = item['status'].toString();

    Color statusColor;

    switch (status) {
      case 'Hadir':
        statusColor = Colors.green;
        break;
      case 'Terlambat':
        statusColor = Colors.orange;
        break;
      case 'Izin':
        statusColor = Colors.blue;
        break;
      case 'Sakit':
        statusColor = Colors.purple;
        break;
      default:
        statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE3F2FD),
              child: Text(
                item['nama'].toString().substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
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
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['jam'].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TAMBAH ABSENSI
  // =========================================================

  void _showTambahAbsensi() {
    String nama = '';
    String nis = '';
    String kelas = 'VII A';
    String status = 'Hadir';
    String jam = '07:00';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    const Text(
                      'Tambah Absensi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      onChanged: (value) {
                        nama = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nama Siswa',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      onChanged: (value) {
                        nis = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'NIS',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: kelas,
                      decoration: InputDecoration(
                        labelText: 'Kelas',
                        prefixIcon: const Icon(Icons.class_),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          const [
                            'VII A',
                            'VII B',
                            'VIII A',
                            'VIII B',
                            'IX A',
                          ].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setModalState(() {
                          kelas = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: status,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        prefixIcon: const Icon(Icons.event_available),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          const [
                            'Hadir',
                            'Terlambat',
                            'Izin',
                            'Sakit',
                            'Alpa',
                          ].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setModalState(() {
                          status = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      onChanged: (value) {
                        jam = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Jam',
                        hintText: 'Contoh: 07:15',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nama.trim().isEmpty || nis.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama dan NIS wajib diisi'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _absensi.insert(0, {
                              'nama': nama.trim(),
                              'nis': nis.trim(),
                              'kelas': kelas,
                              'jam': jam.trim().isEmpty ? '-' : jam.trim(),
                              'status': status,
                            });
                          });

                          Navigator.pop(context);

                          _showMessage('Data absensi berhasil ditambahkan');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Simpan Absensi'),
                      ),
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
  // SNACKBAR
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
