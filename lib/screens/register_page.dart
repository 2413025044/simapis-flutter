import 'package:flutter/material.dart';

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

  String selectedClass = 'X IPA 1';
  bool isPasswordVisible = false;
  bool isKonfirmasiVisible = false;

  @override
  void dispose() {
    nisController.dispose();
    namaController.dispose();
    passwordController.dispose();
    konfirmasiController.dispose();
    super.dispose();
  }

  void register() {
    if (nisController.text.trim().isEmpty ||
        namaController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        konfirmasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (passwordController.text != konfirmasiController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi password tidak sama'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran berhasil'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
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
          // Background gradasi
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

                  // Tombol kembali
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
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

                  // Card Register
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
                          keyboardType: TextInputType.number,
                          decoration: inputDecoration(
                            label: 'NIS',
                            hint: 'Masukkan NIS',
                            icon: Icons.badge_outlined,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nama
                        TextField(
                          controller: namaController,
                          textCapitalization: TextCapitalization.words,
                          decoration: inputDecoration(
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.person_outline_rounded,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Kelas
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
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedClass = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration:
                              inputDecoration(
                                label: 'Password',
                                hint: 'Masukkan password',
                                icon: Icons.lock_outline_rounded,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
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

                        // Konfirmasi password
                        TextField(
                          controller: konfirmasiController,
                          obscureText: !isKonfirmasiVisible,
                          decoration:
                              inputDecoration(
                                label: 'Konfirmasi Password',
                                hint: 'Masukkan ulang password',
                                icon: Icons.lock_reset_outlined,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
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

                        const SizedBox(height: 28),

                        // Tombol daftar
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
                              onPressed: register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
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

                        // Kembali login
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
