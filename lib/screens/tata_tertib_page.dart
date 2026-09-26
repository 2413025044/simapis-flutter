import 'package:flutter/material.dart';

class TataTertibPage extends StatefulWidget {
  const TataTertibPage({super.key});

  @override
  State<TataTertibPage> createState() => _TataTertibPageState();
}

class _TataTertibPageState extends State<TataTertibPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _tataTertib = [
    {
      'kategori': 'Kedisiplinan',
      'pelanggaran': 'Datang terlambat ke sekolah',
      'poin': 10,
      'sanksi': 'Teguran dan pembinaan',
    },
    {
      'kategori': 'Seragam',
      'pelanggaran': 'Tidak menggunakan seragam lengkap',
      'poin': 5,
      'sanksi': 'Teguran',
    },
    {
      'kategori': 'Tugas',
      'pelanggaran': 'Tidak mengerjakan tugas',
      'poin': 15,
      'sanksi': 'Pembinaan wali kelas',
    },
    {
      'kategori': 'Kehadiran',
      'pelanggaran': 'Keluar sekolah tanpa izin',
      'poin': 25,
      'sanksi': 'Pemanggilan orang tua',
    },
    {
      'kategori': 'Rambut',
      'pelanggaran': 'Model rambut tidak sesuai aturan',
      'poin': 10,
      'sanksi': 'Teguran dan pembinaan',
    },
    {
      'kategori': 'Barang Terlarang',
      'pelanggaran': 'Membawa barang yang dilarang',
      'poin': 50,
      'sanksi': 'Pemanggilan orang tua',
    },
    {
      'kategori': 'Kehadiran',
      'pelanggaran': 'Membolos sekolah',
      'poin': 75,
      'sanksi': 'Pemanggilan orang tua dan pembinaan',
    },
  ];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) {
      return _tataTertib;
    }

    return _tataTertib.where((item) {
      final kategori = item['kategori'].toString().toLowerCase();
      final pelanggaran = item['pelanggaran'].toString().toLowerCase();
      final sanksi = item['sanksi'].toString().toLowerCase();

      return kategori.contains(_searchQuery) ||
          pelanggaran.contains(_searchQuery) ||
          sanksi.contains(_searchQuery);
    }).toList();
  }

  Color _getCategoryColor(String kategori) {
    switch (kategori) {
      case 'Kedisiplinan':
        return Colors.blue;
      case 'Seragam':
        return Colors.indigo;
      case 'Tugas':
        return Colors.orange;
      case 'Kehadiran':
        return Colors.red;
      case 'Rambut':
        return Colors.purple;
      case 'Barang Terlarang':
        return Colors.deepOrange;
      default:
        return Colors.blueGrey;
    }
  }

  void _showDetail(Map<String, dynamic> item) {
    final Color categoryColor = _getCategoryColor(item['kategori'].toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
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

                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.gavel_rounded,
                        color: categoryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['kategori'].toString(),
                            style: TextStyle(
                              color: categoryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Detail Tata Tertib',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _detailRow(
                  Icons.warning_amber_rounded,
                  'Pelanggaran',
                  item['pelanggaran'].toString(),
                ),

                const SizedBox(height: 16),

                _detailRow(Icons.stars_rounded, 'Poin', '${item['poin']} poin'),

                const SizedBox(height: 16),

                _detailRow(
                  Icons.gavel_rounded,
                  'Sanksi',
                  item['sanksi'].toString(),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Tutup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.info_outline,
            color: Color(0xFF1565C0),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showForm({int? index}) {
    final bool isEdit = index != null;

    final item = isEdit ? _tataTertib[index] : null;

    final kategoriController = TextEditingController(
      text: item?['kategori']?.toString() ?? '',
    );

    final pelanggaranController = TextEditingController(
      text: item?['pelanggaran']?.toString() ?? '',
    );

    final poinController = TextEditingController(
      text: item?['poin']?.toString() ?? '',
    );

    final sanksiController = TextEditingController(
      text: item?['sanksi']?.toString() ?? '',
    );

    String kategori = item?['kategori']?.toString() ?? 'Kedisiplinan';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                      isEdit ? 'Edit Tata Tertib' : 'Tambah Tata Tertib',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: kategori,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon: const Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Kedisiplinan',
                          child: Text('Kedisiplinan'),
                        ),
                        DropdownMenuItem(
                          value: 'Seragam',
                          child: Text('Seragam'),
                        ),
                        DropdownMenuItem(value: 'Tugas', child: Text('Tugas')),
                        DropdownMenuItem(
                          value: 'Kehadiran',
                          child: Text('Kehadiran'),
                        ),
                        DropdownMenuItem(
                          value: 'Rambut',
                          child: Text('Rambut'),
                        ),
                        DropdownMenuItem(
                          value: 'Barang Terlarang',
                          child: Text('Barang Terlarang'),
                        ),
                        DropdownMenuItem(
                          value: 'Lainnya',
                          child: Text('Lainnya'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() {
                            kategori = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: pelanggaranController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Jenis Pelanggaran',
                        hintText: 'Contoh: Datang terlambat',
                        prefixIcon: const Icon(Icons.warning_amber_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: poinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Poin Pelanggaran',
                        hintText: 'Contoh: 10',
                        prefixIcon: const Icon(Icons.stars_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: sanksiController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Sanksi',
                        hintText: 'Contoh: Teguran dan pembinaan',
                        prefixIcon: const Icon(Icons.gavel_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (pelanggaranController.text.trim().isEmpty) {
                            _showSnackBar('Jenis pelanggaran harus diisi');
                            return;
                          }

                          final int poin =
                              int.tryParse(poinController.text.trim()) ?? 0;

                          if (poin <= 0) {
                            _showSnackBar('Poin harus lebih dari 0');
                            return;
                          }

                          if (sanksiController.text.trim().isEmpty) {
                            _showSnackBar('Sanksi harus diisi');
                            return;
                          }

                          final data = {
                            'kategori': kategori,
                            'pelanggaran': pelanggaranController.text.trim(),
                            'poin': poin,
                            'sanksi': sanksiController.text.trim(),
                          };

                          setState(() {
                            if (isEdit) {
                              _tataTertib[index] = data;
                            } else {
                              _tataTertib.add(data);
                            }
                          });

                          Navigator.pop(sheetContext);

                          _showSnackBar(
                            isEdit
                                ? 'Data berhasil diperbarui'
                                : 'Tata tertib berhasil ditambahkan',
                          );
                        },
                        icon: Icon(isEdit ? Icons.save : Icons.add),
                        label: Text(
                          isEdit ? 'Simpan Perubahan' : 'Tambah Data',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
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

  void _deleteData(int index) {
    final item = _tataTertib[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Tata Tertib?'),
          content: Text('Data "${item['pelanggaran']}" akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tataTertib.removeAt(index);
                });

                Navigator.pop(dialogContext);

                _showSnackBar('Data tata tertib berhasil dihapus');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> item, int index) {
    final Color categoryColor = _getCategoryColor(item['kategori'].toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showDetail(item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['kategori'].toString(),
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'detail') {
                        _showDetail(item);
                      } else if (value == 'edit') {
                        _showForm(index: index);
                      } else if (value == 'delete') {
                        _deleteData(index);
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

              const SizedBox(height: 12),

              Text(
                item['pelanggaran'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _smallInfo(
                      Icons.stars_rounded,
                      '${item['poin']} poin',
                    ),
                  ),
                  Expanded(
                    child: _smallInfo(
                      Icons.gavel_rounded,
                      item['sanksi'].toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 2),
        Icon(icon, size: 18, color: const Color(0xFF1565C0)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'Tata Tertib',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSnackBar('Gunakan pencarian untuk mencari tata tertib');
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D1117)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Peraturan Sekolah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kelola tata tertib dan sanksi pelanggaran siswa',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari tata tertib...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                            },
                            icon: const Icon(Icons.clear),
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

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Text(
                  'Daftar Tata Tertib',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${_filteredData.length} aturan',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 65,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tata tertib tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];

                      final originalIndex = _tataTertib.indexOf(item);

                      return _buildRuleCard(item, originalIndex);
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
