import 'package:flutter/material.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _guru = [
    {
      'nip': '198501012010011001',
      'nama': 'Dr. Budi Santoso, S.Pd.',
      'mapel': 'Matematika',
      'telepon': '081234567801',
    },
    {
      'nip': '198703152012022002',
      'nama': 'Siti Rahmawati, S.Pd.',
      'mapel': 'Bahasa Indonesia',
      'telepon': '081234567802',
    },
    {
      'nip': '198902202015031003',
      'nama': 'Andi Wijaya, S.Kom.',
      'mapel': 'Informatika',
      'telepon': '081234567803',
    },
    {
      'nip': '199004102016042004',
      'nama': 'Dewi Lestari, S.Pd.',
      'mapel': 'Bahasa Inggris',
      'telepon': '081234567804',
    },
    {
      'nip': '198612052011051005',
      'nama': 'Rudi Hartono, S.Pd.',
      'mapel': 'IPA',
      'telepon': '081234567805',
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

  List<Map<String, String>> get _filteredGuru {
    if (_searchText.isEmpty) {
      return _guru;
    }

    return _guru.where((guru) {
      final nama = guru['nama']!.toLowerCase();
      final nip = guru['nip']!.toLowerCase();
      final mapel = guru['mapel']!.toLowerCase();

      return nama.contains(_searchText) ||
          nip.contains(_searchText) ||
          mapel.contains(_searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Data Guru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data guru diperbarui'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      // =====================================================
      // TAMBAH GURU
      // =====================================================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: () {
          _showGuruForm();
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Guru'),
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: Column(
        children: [
          _buildSearchBox(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Guru',
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
                    '${_filteredGuru.length} Guru',
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
            child: _filteredGuru.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: _filteredGuru.length,
                    itemBuilder: (context, index) {
                      final guru = _filteredGuru[index];

                      return _buildGuruCard(guru, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SEARCH BOX
  // =====================================================

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
            hintText: 'Cari nama, NIP, atau mata pelajaran...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
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

  // =====================================================
  // GURU CARD
  // =====================================================

  Widget _buildGuruCard(Map<String, String> guru, int index) {
    final String nama = guru['nama']!;
    final String nip = guru['nip']!;
    final String mapel = guru['mapel']!;
    final String telepon = guru['telepon']!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showDetailGuru(guru);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FOTO / ICON GURU
                  CircleAvatar(
                    radius: 27,
                    backgroundColor: const Color(0xFFE3F2FD),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF1565C0),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // INFORMASI GURU
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          'NIP: $nip',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              size: 16,
                              color: Color(0xFF1565C0),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                mapel,
                                style: const TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // MENU
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'detail') {
                        _showDetailGuru(guru);
                      } else if (value == 'edit') {
                        _showGuruForm(index: index, guru: guru);
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

                  Expanded(child: _smallInfo(Icons.school_outlined, mapel)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // SMALL INFO
  // =====================================================

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

  // =====================================================
  // EMPTY STATE
  // =====================================================

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
              'Guru tidak ditemukan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Coba cari menggunakan nama, NIP, atau mata pelajaran.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DETAIL GURU
  // =====================================================

  void _showDetailGuru(Map<String, String> guru) {
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
                // HANDLE
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                // AVATAR
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
                  guru['nama']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'NIP ${guru['nip']}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 20),

                _detailRow(Icons.badge_outlined, 'NIP', guru['nip']!),

                _detailRow(Icons.person_outline, 'Nama Lengkap', guru['nama']!),

                _detailRow(
                  Icons.menu_book_outlined,
                  'Mata Pelajaran',
                  guru['mapel']!,
                ),

                _detailRow(
                  Icons.phone_outlined,
                  'Nomor Telepon',
                  guru['telepon']!,
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);

                      _showGuruForm(guru: guru);
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
                    label: const Text('Edit Data Guru'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // DETAIL ROW
  // =====================================================

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

  // =====================================================
  // FORM TAMBAH / EDIT GURU
  // =====================================================

  void _showGuruForm({int? index, Map<String, String>? guru}) {
    final bool isEdit = guru != null;

    final nipController = TextEditingController(text: guru?['nip'] ?? '');

    final namaController = TextEditingController(text: guru?['nama'] ?? '');

    final teleponController = TextEditingController(
      text: guru?['telepon'] ?? '',
    );

    String selectedMapel = guru?['mapel'] ?? 'Matematika';

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
                      // HANDLE
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
                        isEdit ? 'Edit Data Guru' : 'Tambah Guru',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        isEdit
                            ? 'Perbarui informasi guru'
                            : 'Masukkan data guru baru',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),

                      const SizedBox(height: 20),

                      // NIP
                      _formField(
                        controller: nipController,
                        label: 'NIP',
                        hint: 'Masukkan NIP guru',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 14),

                      // NAMA
                      _formField(
                        controller: namaController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama guru',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 14),

                      // MAPEL
                      DropdownButtonFormField<String>(
                        value: selectedMapel,
                        decoration: InputDecoration(
                          labelText: 'Mata Pelajaran',
                          prefixIcon: const Icon(
                            Icons.menu_book_outlined,
                            color: Color(0xFF1565C0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            const [
                              'Matematika',
                              'Bahasa Indonesia',
                              'Bahasa Inggris',
                              'Informatika',
                              'IPA',
                              'IPS',
                              'Pendidikan Agama',
                              'PPKn',
                              'Seni Budaya',
                              'PJOK',
                            ].map((mapel) {
                              return DropdownMenuItem(
                                value: mapel,
                                child: Text(mapel),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedMapel = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      // TELEPON
                      _formField(
                        controller: teleponController,
                        label: 'Nomor Telepon',
                        hint: 'Contoh: 081234567890',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 24),

                      // SIMPAN
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (nipController.text.trim().isEmpty ||
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
                              'nip': nipController.text.trim(),
                              'nama': namaController.text.trim(),
                              'mapel': selectedMapel,
                              'telepon': teleponController.text.trim(),
                            };

                            setState(() {
                              if (isEdit && index != null) {
                                _guru[index] = dataBaru;
                              } else {
                                _guru.add(dataBaru);
                              }
                            });

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEdit
                                      ? 'Data guru berhasil diperbarui'
                                      : 'Guru berhasil ditambahkan',
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
                            isEdit ? 'Simpan Perubahan' : 'Tambah Guru',
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

  // =====================================================
  // FORM FIELD
  // =====================================================

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

  // =====================================================
  // KONFIRMASI HAPUS
  // =====================================================

  void _confirmDelete(int index) {
    final guru = _guru[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Guru?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus data ${guru['nama']}?',
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
                  _guru.removeAt(index);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data guru berhasil dihapus'),
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
