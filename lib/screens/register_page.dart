import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiController = TextEditingController();

  static const String apiUrl = 'http://localhost/simapis_api/siswa.php';

  String selectedClass = 'X IPA 1';
  String selectedGender = 'L';

  bool isPasswordVisible = false;
  bool isKonfirmasiVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    passwordController.dispose();
    konfirmasiController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // PROSES REGISTRASI SISWA KE DATABASE
  Future<void> register() async {
    final String nis = nisController.text.trim();
    final String nama = namaController.text.trim();
    final String password = passwordController.text;
    final String konfirmasi = konfirmasiController.text;

    if (nis.isEmpty || nama.isEmpty || password.isEmpty || konfirmasi.isEmpty) {
      showMessage('Semua data wajib diisi.');
      return;
    }

    if (password.length < 6) {
      showMessage('Password minimal 6 karakter.');
      return;
    }

    if (password != konfirmasi) {
      showMessage('Konfirmasi password tidak sama.');
      return;
    }

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'action': 'create',
              'nis': nis,
              'nama': nama,
              'kelas': selectedClass,
              'jenis_kelamin': selectedGender,
              'username': nis,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      dynamic result;

      try {
        result = jsonDecode(response.body);
      } on FormatException {
        showMessage('Respons server tidak valid. Periksa siswa.php.');
        return;
      }

      if (result is! Map) {
        showMessage('Format respons server tidak valid.');
        return;
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          result['success'] == true) {
        showMessage(
          'Registrasi berhasil! Silakan login menggunakan NIS dan password.',
        );

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        showMessage(
          (result['message'] ?? 'Registrasi gagal. Periksa kembali data kamu.')
              .toString(),
        );
      }
    } on TimeoutException {
      showMessage('Server terlalu lama merespons. Coba lagi.');
    } on http.ClientException {
      showMessage('API tidak dapat diakses. Periksa Apache dan CORS.');
    } catch (e) {
      showMessage('Terjadi kesalahan saat registrasi. Periksa koneksi API.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // BACKGROUND GRADASI
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF42A5F5),
                  Color(0xFF1565C0),
                  Color(0xFF0D1117),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // TOMBOL KEMBALI
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: isLoading
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Buat Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Daftarkan akun siswa SIMAPIS',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 35),

                  // CARD REGISTER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registrasi Siswa',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1117),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Lengkapi data untuk membuat akun',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),

                        const SizedBox(height: 25),

                        // NIS
                        TextField(
                          controller: nisController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.text,
                          decoration: inputDecoration(
                            label: 'NIS',
                            hint: 'Masukkan NIS',
                            icon: Icons.badge_outlined,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // NAMA
                        TextField(
                          controller: namaController,
                          enabled: !isLoading,
                          textCapitalization: TextCapitalization.words,
                          decoration: inputDecoration(
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.person_outline_rounded,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // KELAS
                        DropdownButtonFormField<String>(
                          initialValue: selectedClass,
                          decoration: inputDecoration(
                            label: 'Kelas',
                            hint: 'Pilih kelas',
                            icon: Icons.class_outlined,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'X IPA 1',
                              child: Text('X IPA 1'),
                            ),
                            DropdownMenuItem(
                              value: 'X IPA 2',
                              child: Text('X IPA 2'),
                            ),
                            DropdownMenuItem(
                              value: 'X IPS 1',
                              child: Text('X IPS 1'),
                            ),
                            DropdownMenuItem(
                              value: 'XI IPA 1',
                              child: Text('XI IPA 1'),
                            ),
                            DropdownMenuItem(
                              value: 'XI IPA 2',
                              child: Text('XI IPA 2'),
                            ),
                            DropdownMenuItem(
                              value: 'XII IPA 1',
                              child: Text('XII IPA 1'),
                            ),
                            DropdownMenuItem(
                              value: 'XII IPS 1',
                              child: Text('XII IPS 1'),
                            ),
                          ],
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedClass = value;
                                    });
                                  }
                                },
                        ),

                        const SizedBox(height: 16),

                        // JENIS KELAMIN
                        DropdownButtonFormField<String>(
                          initialValue: selectedGender,
                          decoration: inputDecoration(
                            label: 'Jenis Kelamin',
                            hint: 'Pilih jenis kelamin',
                            icon: Icons.wc_outlined,
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
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  }
                                },
                        ),

                        const SizedBox(height: 16),

                        // PASSWORD
                        TextField(
                          controller: passwordController,
                          enabled: !isLoading,
                          obscureText: !isPasswordVisible,
                          decoration:
                              inputDecoration(
                                label: 'Password',
                                hint: 'Masukkan password',
                                icon: Icons.lock_outline_rounded,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),

                        const SizedBox(height: 16),

                        // KONFIRMASI PASSWORD
                        TextField(
                          controller: konfirmasiController,
                          enabled: !isLoading,
                          obscureText: !isKonfirmasiVisible,
                          decoration:
                              inputDecoration(
                                label: 'Konfirmasi Password',
                                hint: 'Masukkan ulang password',
                                icon: Icons.lock_reset_outlined,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            isKonfirmasiVisible =
                                                !isKonfirmasiVisible;
                                          });
                                        },
                                  icon: Icon(
                                    isKonfirmasiVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),

                        const SizedBox(height: 12),

                        // INFORMASI USERNAME
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Username login otomatis menggunakan NIS yang didaftarkan.',
                            style: TextStyle(
                              color: Color(0xFF1565C0),
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // TOMBOL DAFTAR
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF42A5F5),
                                  Color(0xFF1565C0),
                                  Color(0xFF0D1117),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ElevatedButton(
                              onPressed: isLoading ? null : register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                disabledForegroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'DAFTAR',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // KEMBALI LOGIN
                        Center(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text(
                              'Sudah punya akun? Login',
                              style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    '© 2026 SIMAPIS',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
