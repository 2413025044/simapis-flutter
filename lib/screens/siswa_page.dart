import 'package:flutter/material.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _siswa = [
    {
      'nis': '001234',
      'nama': 'Ahmad Rizky',
      'kelas': 'X IPA 1',
      'gender': 'Laki-laki',
      'telepon': '081234567890',
    },
    {
      'nis': '001235',
      'nama': 'Siti Aulia',
      'kelas': 'X IPA 2',
      'gender': 'Perempuan',
      'telepon': '081234567891',
    },
    {
      'nis': '001236',
      'nama': 'Budi Pratama',
      'kelas': 'X IPS 1',
      'gender': 'Laki-laki',
      'telepon': '081234567892',
    },
    {
      'nis': '001237',
      'nama': 'Nabila Putri',
      'kelas': 'XI IPA 1',
      'gender': 'Perempuan',
      'telepon': '081234567893',
    },
    {
      'nis': '001238',
      'nama': 'Rizky Maulana',
      'kelas': 'XI IPA 2',
      'gender': 'Laki-laki',
      'telepon': '081234567894',
    },
  ];

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredSiswa {
    if (_searchText.isEmpty) {
      return _siswa;
    }

    return _siswa.where((siswa) {
      final nama = siswa['nama']!.toLowerCase();
      final nis = siswa['nis']!.toLowerCase();
      final kelas = siswa['kelas']!.toLowerCase();

      return nama.contains(_searchText) ||
          nis.contains(_searchText) ||
          kelas.contains(_searchText);
    }).toList();
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
          'Data Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data siswa diperbarui'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: () {
          _showSiswaForm();
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Siswa'),
      ),

      body: Column(
        children: [
          _buildSearchBox(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Siswa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_filteredSiswa.length} Siswa',
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _filteredSiswa.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: _filteredSiswa.length,
                    itemBuilder: (context, index) {
                      final siswa = _filteredSiswa[index];

                      return _buildSiswaCard(siswa, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      color: const Color(0xFF1565C0),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari nama, NIS, atau kelas...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
            suffixIcon: _searchText.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSiswaCard(Map<String, String> siswa, int index) {
    final String nama = siswa['nama']!;
    final String nis = siswa['nis']!;
    final String kelas = siswa['kelas']!;
    final String gender = siswa['gender']!;
    final String telepon = siswa['telepon']!;

    final bool lakiLaki = gender == 'Laki-laki';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showDetailSiswa(siswa);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: lakiLaki
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFFCE4EC),
                    child: Icon(
                      lakiLaki ? Icons.person : Icons.person_2,
                      size: 30,
                      color: lakiLaki
                          ? const Color(0xFF1565C0)
                          : const Color(0xFFD81B60),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'NIS: $nis',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Row(
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 16,
                              color: Color(0xFF1565C0),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              kelas,
                              style: const TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'detail') {
                        _showDetailSiswa(siswa);
                      } else if (value == 'edit') {
                        _showSiswaForm(index: index, siswa: siswa);
                      } else if (value == 'hapus') {
                        _confirmDelete(index);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'detail',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 20),
                            SizedBox(width: 10),
                            Text('Lihat Detail'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20),
                            SizedBox(width: 10),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'hapus',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text('Hapus'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 20),

              Row(
                children: [
                  Expanded(child: _smallInfo(Icons.phone_outlined, telepon)),
                  Expanded(child: _smallInfo(Icons.wc_outlined, gender)),
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
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 75,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 15),

            const Text(
              'Siswa tidak ditemukan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Coba cari menggunakan nama, NIS, atau kelas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailSiswa(Map<String, String> siswa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                CircleAvatar(
                  radius: 38,
                  backgroundColor: const Color(0xFFE3F2FD),
                  child: const Icon(
                    Icons.person,
                    size: 45,
                    color: Color(0xFF1565C0),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  siswa['nama']!,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'NIS ${siswa['nis']}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 20),

                _detailRow(Icons.badge_outlined, 'NIS', siswa['nis']!),

                _detailRow(
                  Icons.person_outline,
                  'Nama Lengkap',
                  siswa['nama']!,
                ),

                _detailRow(Icons.school_outlined, 'Kelas', siswa['kelas']!),

                _detailRow(
                  Icons.wc_outlined,
                  'Jenis Kelamin',
                  siswa['gender']!,
                ),

                _detailRow(
                  Icons.phone_outlined,
                  'Nomor Telepon',
                  siswa['telepon']!,
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSiswaForm(siswa: siswa);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Data Siswa'),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF1565C0)),
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
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSiswaForm({int? index, Map<String, String>? siswa}) {
    final bool isEdit = siswa != null;

    final nisController = TextEditingController(text: siswa?['nis'] ?? '');

    final namaController = TextEditingController(text: siswa?['nama'] ?? '');

    final teleponController = TextEditingController(
      text: siswa?['telepon'] ?? '',
    );

    String selectedKelas = siswa?['kelas'] ?? 'X IPA 1';
    String selectedGender = siswa?['gender'] ?? 'Laki-laki';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: SafeArea(
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
                        isEdit ? 'Edit Data Siswa' : 'Tambah Siswa',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        isEdit
                            ? 'Perbarui informasi siswa'
                            : 'Masukkan data siswa baru',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 20),

                      _formField(
                        controller: nisController,
                        label: 'NIS',
                        hint: 'Contoh: 001239',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      _formField(
                        controller: namaController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama siswa',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        value: selectedKelas,
                        decoration: InputDecoration(
                          labelText: 'Kelas',
                          prefixIcon: const Icon(
                            Icons.school_outlined,
                            color: Color(0xFF1565C0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            const [
                              'X IPA 1',
                              'X IPA 2',
                              'X IPS 1',
                              'XI IPA 1',
                              'XI IPA 2',
                              'XII IPA 1',
                              'XII IPS 1',
                            ].map((kelas) {
                              return DropdownMenuItem(
                                value: kelas,
                                child: Text(kelas),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedKelas = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: const Icon(
                            Icons.wc_outlined,
                            color: Color(0xFF1565C0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const ['Laki-laki', 'Perempuan'].map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedGender = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      _formField(
                        controller: teleponController,
                        label: 'Nomor Telepon',
                        hint: 'Contoh: 081234567890',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (nisController.text.trim().isEmpty ||
                                namaController.text.trim().isEmpty ||
                                teleponController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Semua data harus diisi'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final dataBaru = {
                              'nis': nisController.text.trim(),
                              'nama': namaController.text.trim(),
                              'kelas': selectedKelas,
                              'gender': selectedGender,
                              'telepon': teleponController.text.trim(),
                            };

                            setState(() {
                              if (isEdit && index != null) {
                                _siswa[index] = dataBaru;
                              } else {
                                _siswa.add(dataBaru);
                              }
                            });

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEdit
                                      ? 'Data siswa berhasil diperbarui'
                                      : 'Siswa berhasil ditambahkan',
                                ),
                                backgroundColor: const Color(0xFF2E7D32),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isEdit ? 'Simpan Perubahan' : 'Tambah Siswa',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    final siswa = _siswa[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Siswa?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus data ${siswa['nama']}?',
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
                  _siswa.removeAt(index);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data siswa berhasil dihapus'),
                    backgroundColor: Colors.red,
                  ),
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
