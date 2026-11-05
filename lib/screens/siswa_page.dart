import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SiswaPage extends StatefulWidget {
  const SiswaPage({super.key});

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  static const String apiUrl = 'http://localhost/simapis_api/siswa.php';

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _siswa = [];
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
    _loadSiswa();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool error = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _loadSiswa() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final response = await http
          .get(Uri.parse(apiUrl), headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          result is Map &&
          result['success'] == true) {
        final List<dynamic> data = result['data'] ?? [];

        if (!mounted) return;

        setState(() {
          _siswa = data.map((item) => Map<String, dynamic>.from(item)).toList();
        });
      } else {
        throw Exception(
          result is Map
              ? result['message'] ?? 'Gagal mengambil data siswa'
              : 'Respons server tidak valid',
        );
      }
    } catch (e) {
      _showMessage('Gagal mengambil data: $e', error: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _sendData(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      final result = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          result is Map &&
          result['success'] == true) {
        _showMessage(result['message'] ?? 'Berhasil');
        await _loadSiswa();
        return true;
      }

      _showMessage(
        result is Map
            ? (result['message'] ?? 'Operasi gagal').toString()
            : 'Respons server tidak valid',
        error: true,
      );
      return false;
    } catch (e) {
      _showMessage('Gagal menghubungi server: $e', error: true);
      return false;
    }
  }

  List<Map<String, dynamic>> get _filteredSiswa {
    if (_searchText.isEmpty) return _siswa;

    return _siswa.where((siswa) {
      final nama = (siswa['nama'] ?? '').toString().toLowerCase();
      final nis = (siswa['nis'] ?? '').toString().toLowerCase();
      final kelas = (siswa['kelas'] ?? '').toString().toLowerCase();

      return nama.contains(_searchText) ||
          nis.contains(_searchText) ||
          kelas.contains(_searchText);
    }).toList();
  }

  String _genderLabel(dynamic value) {
    if (value == 'L') return 'Laki-laki';
    if (value == 'P') return 'Perempuan';
    return '-';
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
            onPressed: _isLoading ? null : _loadSiswa,
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: () => _showSiswaForm(),
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSiswa.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: _filteredSiswa.length,
                    itemBuilder: (context, index) {
                      final siswa = _filteredSiswa[index];
                      return _buildSiswaCard(siswa);
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
            prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
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

  Widget _buildSiswaCard(Map<String, dynamic> siswa) {
    final nama = (siswa['nama'] ?? '-').toString();
    final nis = (siswa['nis'] ?? '-').toString();
    final kelas = (siswa['kelas'] ?? '-').toString();
    final gender = _genderLabel(siswa['jenis_kelamin']);
    final telepon = (siswa['telepon'] ?? '-').toString();
    final bool lakiLaki = siswa['jenis_kelamin'] == 'L';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetailSiswa(siswa),
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
                      Icons.person,
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
                        _showSiswaForm(siswa: siswa);
                      } else if (value == 'hapus') {
                        _confirmDelete(siswa);
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
                  Expanded(child: _smallInfo(Icons.wc_outlined, gender)),
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
              'Belum ada data siswa atau pencarian tidak ditemukan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailSiswa(Map<String, dynamic> siswa) {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    (siswa['nama'] ?? '-').toString(),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIS ${siswa['nis'] ?? '-'}'),
                  const SizedBox(height: 20),
                  _detailRow('NIS', siswa['nis']),
                  _detailRow('Nama Lengkap', siswa['nama']),
                  _detailRow('Kelas', siswa['kelas']),
                  _detailRow(
                    'Jenis Kelamin',
                    _genderLabel(siswa['jenis_kelamin']),
                  ),
                  _detailRow('Nomor Telepon', siswa['telepon']),
                  _detailRow('Alamat', siswa['alamat']),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _showSiswaForm(siswa: siswa);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Data Siswa'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, dynamic value) {
    final text = (value == null || value.toString().isEmpty)
        ? '-'
        : value.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1565C0)),
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
                  text,
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

  void _showSiswaForm({Map<String, dynamic>? siswa}) {
    final bool isEdit = siswa != null;

    final nisController = TextEditingController(
      text: siswa?['nis']?.toString() ?? '',
    );
    final namaController = TextEditingController(
      text: siswa?['nama']?.toString() ?? '',
    );
    final kelasController = TextEditingController(
      text: siswa?['kelas']?.toString() ?? '',
    );
    final teleponController = TextEditingController(
      text: siswa?['telepon']?.toString() ?? '',
    );
    final alamatController = TextEditingController(
      text: siswa?['alamat']?.toString() ?? '',
    );
    final usernameController = TextEditingController(
      text: siswa?['username']?.toString() ?? '',
    );
    final passwordController = TextEditingController();

    String selectedGender = siswa?['jenis_kelamin'] == 'P' ? 'P' : 'L';

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
                20,
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
                      Text(
                        isEdit ? 'Edit Data Siswa' : 'Tambah Siswa',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                        hint: 'Masukkan NIS',
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
                      _formField(
                        controller: kelasController,
                        label: 'Kelas',
                        hint: 'Contoh: X PPLG 1',
                        icon: Icons.school_outlined,
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
                        items: const [
                          DropdownMenuItem(
                            value: 'L',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'P',
                            child: Text('Perempuan'),
                          ),
                        ],
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
                      const SizedBox(height: 14),
                      _formField(
                        controller: alamatController,
                        label: 'Alamat',
                        hint: 'Masukkan alamat siswa',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Akun Login Siswa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _formField(
                        controller: usernameController,
                        label: 'Username',
                        hint: 'Username untuk login siswa',
                        icon: Icons.account_circle_outlined,
                      ),
                      const SizedBox(height: 14),
                      _formField(
                        controller: passwordController,
                        label: isEdit ? 'Password Baru (opsional)' : 'Password',
                        hint: isEdit
                            ? 'Kosongkan jika tidak diganti'
                            : 'Buat password akun siswa',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (nisController.text.trim().isEmpty ||
                                      namaController.text.trim().isEmpty ||
                                      kelasController.text.trim().isEmpty) {
                                    _showMessage(
                                      'NIS, nama, dan kelas wajib diisi.',
                                      error: true,
                                    );
                                    return;
                                  }

                                  if (!isEdit &&
                                      (usernameController.text.trim().isEmpty ||
                                          passwordController.text.isEmpty)) {
                                    _showMessage(
                                      'Username dan password wajib diisi.',
                                      error: true,
                                    );
                                    return;
                                  }

                                  setModalState(() => isSaving = true);

                                  final Map<String, dynamic> data = {
                                    'action': isEdit ? 'update' : 'create',
                                    'nis': nisController.text.trim(),
                                    'nama': namaController.text.trim(),
                                    'kelas': kelasController.text.trim(),
                                    'jenis_kelamin': selectedGender,
                                    'telepon': teleponController.text.trim(),
                                    'alamat': alamatController.text.trim(),
                                    'username': usernameController.text.trim(),
                                    'password': passwordController.text,
                                  };

                                  if (isEdit) {
                                    data['id'] = siswa['id'];
                                  }

                                  final success = await _sendData(data);

                                  if (success && mounted) {
                                    Navigator.pop(sheetContext);
                                  } else if (mounted) {
                                    setModalState(() => isSaving = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
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
                                  isEdit ? 'Simpan Perubahan' : 'Tambah Siswa',
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
      nisController.dispose();
      namaController.dispose();
      kelasController.dispose();
      teleponController.dispose();
      alamatController.dispose();
      usernameController.dispose();
      passwordController.dispose();
    });
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
        prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> siswa) {
    showDialog(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await _sendData({'action': 'delete', 'id': siswa['id']});
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
