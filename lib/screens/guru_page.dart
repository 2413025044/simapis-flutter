import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GuruPage extends StatefulWidget {
  const GuruPage({super.key});

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  static const String apiUrl = 'http://localhost/simapis_api/guru.php';
  static const Color primaryColor = Color(0xFF1565C0);

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _guru = [];
  String _searchText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
    _loadGuru();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================
  // AMBIL DATA GURU DARI API
  // =========================

  Future<void> _loadGuru() async {
    setState(() => _isLoading = true);

    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 15));

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        final List data = result['data'] ?? [];

        if (!mounted) return;

        setState(() {
          _guru = data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      } else {
        throw Exception(result['message'] ?? 'Gagal mengambil data guru');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Gagal mengambil data guru: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================
  // KIRIM DATA KE API
  // =========================

  Future<Map<String, dynamic>> _sendData(Map<String, dynamic> data) async {
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 15));

    final result = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        result['success'] == true) {
      return Map<String, dynamic>.from(result);
    }

    throw Exception(result['message'] ?? 'Permintaan gagal');
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredGuru {
    if (_searchText.isEmpty) return _guru;

    return _guru.where((guru) {
      final nama = (guru['nama'] ?? '').toString().toLowerCase();
      final nip = (guru['nip'] ?? '').toString().toLowerCase();
      final mapel = (guru['mata_pelajaran'] ?? '').toString().toLowerCase();

      return nama.contains(_searchText) ||
          nip.contains(_searchText) ||
          mapel.contains(_searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Data Guru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: _loadGuru, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _showGuruForm(),
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Guru'),
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
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredGuru.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadGuru,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: _filteredGuru.length,
                      itemBuilder: (context, index) {
                        final guru = _filteredGuru[index];
                        return _buildGuruCard(guru);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SEARCH
  // =========================

  Widget _buildSearchBox() {
    return Container(
      color: primaryColor,
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
            prefixIcon: const Icon(Icons.search, color: primaryColor),
            suffixIcon: _searchText.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _searchController.clear,
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

  // =========================
  // KARTU GURU
  // =========================

  Widget _buildGuruCard(Map<String, dynamic> guru) {
    final nama = (guru['nama'] ?? '-').toString();
    final nip = (guru['nip'] ?? '-').toString();
    final mapel = (guru['mata_pelajaran'] ?? '-').toString();
    final telepon = (guru['telepon'] ?? '-').toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetailGuru(guru),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 27,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(Icons.person, size: 30, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
                        Text(
                          mapel,
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'detail') {
                        _showDetailGuru(guru);
                      } else if (value == 'edit') {
                        _showGuruForm(guru: guru);
                      } else if (value == 'hapus') {
                        _confirmDelete(guru);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'detail',
                        child: Text('Lihat Detail'),
                      ),
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'hapus', child: Text('Hapus')),
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

  Widget _smallInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'Belum ada data guru atau data tidak cocok dengan pencarian.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // =========================
  // DETAIL GURU
  // =========================

  void _showDetailGuru(Map<String, dynamic> guru) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
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
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.person, size: 45, color: primaryColor),
                ),
                const SizedBox(height: 12),
                Text(
                  (guru['nama'] ?? '-').toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _detailRow('NIP', guru['nip']),
                _detailRow('Nama Lengkap', guru['nama']),
                _detailRow('Jabatan', guru['jabatan']),
                _detailRow('Mata Pelajaran', guru['mata_pelajaran']),
                _detailRow('Nomor Telepon', guru['telepon']),
                _detailRow('Alamat', guru['alamat']),
                _detailRow('Username', guru['username']),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _showGuruForm(guru: guru);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _detailRow(String title, dynamic value) {
    final displayValue = value == null || value.toString().isEmpty
        ? '-'
        : value.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  displayValue,
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

  // =========================
  // FORM TAMBAH / EDIT GURU
  // =========================

  void _showGuruForm({Map<String, dynamic>? guru}) {
    final isEdit = guru != null;

    final nipController = TextEditingController(
      text: guru?['nip']?.toString() ?? '',
    );
    final namaController = TextEditingController(
      text: guru?['nama']?.toString() ?? '',
    );
    final jabatanController = TextEditingController(
      text: guru?['jabatan']?.toString() ?? '',
    );
    final teleponController = TextEditingController(
      text: guru?['telepon']?.toString() ?? '',
    );
    final alamatController = TextEditingController(
      text: guru?['alamat']?.toString() ?? '',
    );
    final usernameController = TextEditingController(
      text: guru?['username']?.toString() ?? '',
    );
    final passwordController = TextEditingController();

    const daftarMapel = [
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
    ];

    String selectedMapel = (guru?['mata_pelajaran'] ?? 'Matematika').toString();

    if (!daftarMapel.contains(selectedMapel)) {
      selectedMapel = 'Matematika';
    }

    bool isSaving = false;

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
                        isEdit ? 'Edit Data Guru' : 'Tambah Akun Guru',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        isEdit
                            ? 'Perbarui informasi dan akun guru'
                            : 'Isi data guru sekaligus buat akun login',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 20),

                      _formField(
                        nipController,
                        'NIP',
                        'Masukkan NIP guru',
                        Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),

                      _formField(
                        namaController,
                        'Nama Lengkap',
                        'Masukkan nama guru',
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 14),

                      _formField(
                        jabatanController,
                        'Jabatan',
                        'Contoh: Guru Mata Pelajaran',
                        Icons.work_outline,
                      ),
                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        value: selectedMapel,
                        decoration: InputDecoration(
                          labelText: 'Mata Pelajaran',
                          prefixIcon: const Icon(
                            Icons.menu_book_outlined,
                            color: primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: daftarMapel.map((mapel) {
                          return DropdownMenuItem(
                            value: mapel,
                            child: Text(mapel),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => selectedMapel = value);
                          }
                        },
                      ),
                      const SizedBox(height: 14),

                      _formField(
                        teleponController,
                        'Nomor Telepon',
                        'Contoh: 081234567890',
                        Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),

                      _formField(
                        alamatController,
                        'Alamat',
                        'Masukkan alamat guru',
                        Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'AKUN LOGIN GURU',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _formField(
                        usernameController,
                        'Username',
                        'Buat username untuk login',
                        Icons.account_circle_outlined,
                      ),
                      const SizedBox(height: 14),

                      _formField(
                        passwordController,
                        'Password',
                        isEdit
                            ? 'Kosongkan jika tidak ingin mengubah password'
                            : 'Buat password minimal 6 karakter',
                        Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  final nama = namaController.text.trim();
                                  final username = usernameController.text
                                      .trim();
                                  final password = passwordController.text;

                                  if (nama.isEmpty || username.isEmpty) {
                                    _showMessage(
                                      'Nama dan username wajib diisi',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (!isEdit && password.length < 6) {
                                    _showMessage(
                                      'Password minimal 6 karakter',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (isEdit &&
                                      password.isNotEmpty &&
                                      password.length < 6) {
                                    _showMessage(
                                      'Password minimal 6 karakter',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  setModalState(() => isSaving = true);

                                  try {
                                    final data = <String, dynamic>{
                                      'action': isEdit ? 'update' : 'create',
                                      'nip': nipController.text.trim(),
                                      'nama': nama,
                                      'jabatan': jabatanController.text.trim(),
                                      'mata_pelajaran': selectedMapel,
                                      'telepon': teleponController.text.trim(),
                                      'alamat': alamatController.text.trim(),
                                      'username': username,
                                    };

                                    if (isEdit) {
                                      data['id'] = guru['id'];
                                      if (password.isNotEmpty) {
                                        data['password'] = password;
                                      }
                                    } else {
                                      data['password'] = password;
                                    }

                                    final result = await _sendData(data);

                                    if (!mounted) return;

                                    Navigator.pop(sheetContext);
                                    await _loadGuru();

                                    _showMessage(
                                      result['message'] ??
                                          (isEdit
                                              ? 'Data guru diperbarui'
                                              : 'Akun guru berhasil dibuat'),
                                    );
                                  } catch (e) {
                                    if (mounted) {
                                      _showMessage(
                                        e.toString().replaceFirst(
                                          'Exception: ',
                                          '',
                                        ),
                                        isError: true,
                                      );
                                    }
                                  } finally {
                                    setModalState(() => isSaving = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  isEdit
                                      ? 'Simpan Perubahan'
                                      : 'Buat Akun Guru',
                                  style: const TextStyle(
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
    ).whenComplete(() {
      nipController.dispose();
      namaController.dispose();
      jabatanController.dispose();
      teleponController.dispose();
      alamatController.dispose();
      usernameController.dispose();
      passwordController.dispose();
    });
  }

  Widget _formField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  // =========================
  // HAPUS GURU
  // =========================

  void _confirmDelete(Map<String, dynamic> guru) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hapus Guru?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus akun ${guru['nama']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                try {
                  final result = await _sendData({
                    'action': 'delete',
                    'id': guru['id'],
                  });

                  if (!mounted) return;

                  await _loadGuru();
                  _showMessage(
                    result['message'] ?? 'Data guru berhasil dihapus',
                  );
                } catch (e) {
                  if (mounted) {
                    _showMessage(
                      e.toString().replaceFirst('Exception: ', ''),
                      isError: true,
                    );
                  }
                }
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
