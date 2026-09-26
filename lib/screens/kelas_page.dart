import 'package:flutter/material.dart';

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _kelas = [
    {
      'nama': 'VII A',
      'wali': 'Budi Santoso',
      'jumlah': 32,
      'tahun': '2026/2027',
    },
    {
      'nama': 'VII B',
      'wali': 'Siti Rahmawati',
      'jumlah': 30,
      'tahun': '2026/2027',
    },
    {
      'nama': 'VIII A',
      'wali': 'Andi Wijaya',
      'jumlah': 31,
      'tahun': '2026/2027',
    },
    {
      'nama': 'VIII B',
      'wali': 'Dewi Lestari',
      'jumlah': 29,
      'tahun': '2026/2027',
    },
    {
      'nama': 'IX A',
      'wali': 'Rudi Hartono',
      'jumlah': 28,
      'tahun': '2026/2027',
    },
  ];

  String _search = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredKelas {
    return _kelas.where((kelas) {
      return kelas['nama'].toString().toLowerCase().contains(_search) ||
          kelas['wali'].toString().toLowerCase().contains(_search) ||
          kelas['tahun'].toString().toLowerCase().contains(_search);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Data Kelas',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelola Data Kelas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_kelas.length} kelas terdaftar',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),

                const SizedBox(height: 15),

                // SEARCH
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari kelas atau wali kelas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST
          Expanded(
            child: _filteredKelas.isEmpty
                ? const Center(
                    child: Text(
                      'Data kelas tidak ditemukan',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredKelas.length,
                    itemBuilder: (context, index) {
                      final kelas = _filteredKelas[index];

                      return _kelasCard(kelas);
                    },
                  ),
          ),
        ],
      ),

      // TAMBAH KELAS
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: () {
          _showForm();
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kelas'),
      ),
    );
  }

  Widget _kelasCard(Map<String, dynamic> kelas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // ICON
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.class_outlined,
                    color: Color(0xFF1565C0),
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                // INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kelas['nama'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Wali Kelas: ${kelas['wali']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'detail') {
                      _showDetail(kelas);
                    } else if (value == 'edit') {
                      _showForm(kelas: kelas);
                    } else if (value == 'hapus') {
                      _deleteKelas(kelas);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'detail',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined),
                          SizedBox(width: 10),
                          Text('Detail'),
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
                      value: 'hapus',
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

            const Divider(height: 25),

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    Icons.people_outline,
                    '${kelas['jumlah']} Siswa',
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    Icons.calendar_today_outlined,
                    kelas['tahun'],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1565C0)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showDetail(Map<String, dynamic> kelas) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Kelas',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              _detailRow('Nama Kelas', kelas['nama']),
              _detailRow('Wali Kelas', kelas['wali']),
              _detailRow('Jumlah Siswa', '${kelas['jumlah']} siswa'),
              _detailRow('Tahun Ajaran', kelas['tahun']),

              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showForm({Map<String, dynamic>? kelas}) {
    final bool isEdit = kelas != null;

    final namaController = TextEditingController(text: kelas?['nama'] ?? '');

    final jumlahController = TextEditingController(
      text: kelas?['jumlah']?.toString() ?? '',
    );

    String wali = kelas?['wali'] ?? 'Budi Santoso';

    String tahun = kelas?['tahun'] ?? '2026/2027';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'Edit Kelas' : 'Tambah Kelas',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Kelas',
                        prefixIcon: Icon(Icons.class_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: wali,
                      decoration: const InputDecoration(
                        labelText: 'Wali Kelas',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      items:
                          const [
                                'Budi Santoso',
                                'Siti Rahmawati',
                                'Andi Wijaya',
                                'Dewi Lestari',
                                'Rudi Hartono',
                              ]
                              .map(
                                (nama) => DropdownMenuItem(
                                  value: nama,
                                  child: Text(nama),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() {
                            wali = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Siswa',
                        prefixIcon: Icon(Icons.people_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: tahun,
                      decoration: const InputDecoration(
                        labelText: 'Tahun Ajaran',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const ['2025/2026', '2026/2027', '2027/2028']
                          .map(
                            (tahunAjaran) => DropdownMenuItem(
                              value: tahunAjaran,
                              child: Text(tahunAjaran),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() {
                            tahun = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (namaController.text.trim().isEmpty ||
                              jumlahController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nama kelas dan jumlah siswa wajib diisi.',
                                ),
                              ),
                            );
                            return;
                          }

                          final data = {
                            'nama': namaController.text.trim(),
                            'wali': wali,
                            'jumlah': int.tryParse(jumlahController.text) ?? 0,
                            'tahun': tahun,
                          };

                          setState(() {
                            if (isEdit) {
                              final index = _kelas.indexOf(kelas);
                              _kelas[index] = data;
                            } else {
                              _kelas.add(data);
                            }
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEdit
                                    ? 'Data kelas berhasil diperbarui.'
                                    : 'Kelas berhasil ditambahkan.',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteKelas(Map<String, dynamic> kelas) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kelas'),
          content: Text(
            'Apakah kamu yakin ingin menghapus kelas ${kelas['nama']}?',
          ),
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
                  _kelas.remove(kelas);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Data kelas berhasil dihapus.')),
                );
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
}
