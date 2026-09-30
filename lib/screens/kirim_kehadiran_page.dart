import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class KirimKehadiranPage extends StatefulWidget {
  const KirimKehadiranPage({super.key});

  @override
  State<KirimKehadiranPage> createState() => _KirimKehadiranPageState();
}

class _KirimKehadiranPageState extends State<KirimKehadiranPage> {
  CameraController? _cameraController;

  Uint8List? _photoBytes;

  bool _cameraOpened = false;
  bool _isLoading = false;
  bool _isTakingPicture = false;
  bool _sudahDikirim = false;

  String _statusKehadiran = 'Hadir';
  String _waktuKirim = '-';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  // ============================================================
  // BUKA KAMERA
  // ============================================================

  Future<void> _openCamera() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    CameraController? controller;

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _cameraOpened = false;
          _errorMessage = 'Tidak ada kamera yang terdeteksi oleh browser.';
        });
        return;
      }

      // Urutan kamera:
      // 1. Kamera depan
      // 2. Kamera pertama sebagai fallback
      final orderedCameras = <CameraDescription>[
        ...cameras.where(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        ),
        ...cameras.where(
          (camera) => camera.lensDirection != CameraLensDirection.front,
        ),
      ];

      CameraException? lastError;

      for (final camera in orderedCameras) {
        try {
          final testController = CameraController(
            camera,
            ResolutionPreset.low,
            enableAudio: false,
          );

          await testController.initialize();

          controller = testController;
          break;
        } on CameraException catch (e) {
          lastError = e;

          try {
            await controller?.dispose();
          } catch (_) {}

          controller = null;
        }
      }

      if (controller == null) {
        if (!mounted) return;

        final code = lastError?.code ?? 'Unknown';
        final description = lastError?.description ?? 'Tidak ada detail error.';

        setState(() {
          _isLoading = false;
          _cameraOpened = false;
          _errorMessage =
              'Kamera gagal dibuka.\n\n'
              'Kode: $code\n'
              'Detail: $description';
        });

        debugPrint('CAMERA ERROR CODE: $code');
        debugPrint('CAMERA ERROR DESCRIPTION: $description');

        return;
      }

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraOpened = true;
        _isLoading = false;
        _errorMessage = null;
      });
    } on CameraException catch (e) {
      try {
        await controller?.dispose();
      } catch (_) {}

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _cameraOpened = false;
        _errorMessage =
            'Kode: ${e.code}\n'
            'Detail: ${e.description ?? 'Tidak ada detail error.'}';
      });

      debugPrint('CAMERA ERROR CODE: ${e.code}');
      debugPrint('CAMERA ERROR DESCRIPTION: ${e.description}');
    } catch (e) {
      try {
        await controller?.dispose();
      } catch (_) {}

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _cameraOpened = false;
        _errorMessage = 'Terjadi kesalahan:\n$e';
      });

      debugPrint('UNKNOWN CAMERA ERROR: $e');
    }
  }

  // ============================================================
  // AMBIL FOTO
  // ============================================================

  Future<void> _takePicture() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final XFile file = await controller.takePicture();

      final Uint8List bytes = await file.readAsBytes();

      if (!mounted) return;

      setState(() {
        _photoBytes = bytes;
        _sudahDikirim = false;
        _waktuKirim = '-';
        _isTakingPicture = false;
      });

      try {
        await controller.pausePreview();
      } catch (_) {}
    } on CameraException catch (e) {
      if (!mounted) return;

      setState(() {
        _isTakingPicture = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengambil foto.\n'
            '${e.code}: ${e.description ?? ''}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isTakingPicture = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ============================================================
  // FOTO ULANG
  // ============================================================

  Future<void> _retakePicture() async {
    setState(() {
      _photoBytes = null;
      _sudahDikirim = false;
      _waktuKirim = '-';
    });

    try {
      await _cameraController?.resumePreview();
    } catch (_) {}
  }

  // ============================================================
  // TUTUP KAMERA
  // ============================================================

  Future<void> _closeCamera() async {
    try {
      await _cameraController?.dispose();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _cameraController = null;
      _cameraOpened = false;
      _photoBytes = null;
      _sudahDikirim = false;
      _waktuKirim = '-';
      _errorMessage = null;
    });
  }

  // ============================================================
  // KIRIM KEHADIRAN
  // ============================================================

  void _sendAttendance() {
    if (_photoBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan ambil foto terlebih dahulu.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final now = DateTime.now();

    final hour = now.hour.toString().padLeft(2, '0');

    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _sudahDikirim = true;
      _waktuKirim = '$hour:$minute';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bukti kehadiran berhasil dikirim.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  void _showStatus() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Status Kehadiran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Kehadiran',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                _statusKehadiran,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Status Pengiriman',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                _sudahDikirim ? 'Sudah dikirim' : 'Belum dikirim',
                style: TextStyle(
                  color: _sudahDikirim ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Waktu Pengiriman',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                _waktuKirim,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Absensi Siswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_cameraOpened)
            IconButton(
              tooltip: 'Tutup kamera',
              onPressed: _closeCamera,
              icon: const Icon(Icons.close),
            ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildCameraArea()),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CAMERA AREA
  // ============================================================

  Widget _buildCameraArea() {
    // ==========================================================
    // BELUM BUKA KAMERA
    // ==========================================================

    if (!_cameraOpened) {
      return Container(
        width: double.infinity,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 42,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Kamera Absensi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Ambil foto sebagai bukti kehadiran kamu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _openCamera,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.camera_alt),
                    label: Text(
                      _isLoading ? 'Membuka Kamera...' : 'Buka Kamera',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 24,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  OutlinedButton.icon(
                    onPressed: _openCamera,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.no_photography_outlined,
                  color: Colors.white,
                  size: 60,
                ),

                const SizedBox(height: 15),

                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                ElevatedButton.icon(
                  onPressed: _openCamera,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ==========================================================
    // FOTO SUDAH DIAMBIL
    // ==========================================================

    if (_photoBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(_photoBytes!, fit: BoxFit.cover),

          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Foto berhasil diambil',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // ==========================================================
    // LIVE CAMERA
    // ==========================================================

    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        ),

        // FRAME WAJAH
        Center(
          child: Container(
            width: 220,
            height: 290,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(120),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 2,
              ),
            ),
          ),
        ),

        // PETUNJUK
        Positioned(
          top: 15,
          left: 15,
          right: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.face_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Posisikan wajah di dalam area kamera',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),

        // TOMBOL CEKREK
        Positioned(
          bottom: 22,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _isTakingPicture ? null : _takePicture,
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: _isTakingPicture
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color(0xFF1565C0),
                        ),
                      )
                    : const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF1565C0),
                        size: 34,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PANEL BAWAH
  // ============================================================

  Widget _buildBottomPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Status Kehadiran',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              const Spacer(),

              SizedBox(
                width: 135,
                height: 46,
                child: DropdownButtonFormField<String>(
                  initialValue: _statusKehadiran,
                  isDense: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Hadir', child: Text('Hadir')),
                    DropdownMenuItem(value: 'Sakit', child: Text('Sakit')),
                    DropdownMenuItem(value: 'Izin', child: Text('Izin')),
                  ],
                  onChanged: _sudahDikirim
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _statusKehadiran = value;
                          });
                        },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (_photoBytes == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFF1565C0),
                    size: 21,
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Buka kamera dan ambil foto sebagai bukti kehadiran.',
                      style: TextStyle(color: Color(0xFF1565C0), fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

          if (_photoBytes != null) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sudahDikirim ? null : _retakePicture,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Foto Ulang'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sudahDikirim ? null : _sendAttendance,
                    icon: Icon(
                      _sudahDikirim ? Icons.check_circle : Icons.send_outlined,
                      size: 18,
                    ),
                    label: Text(_sudahDikirim ? 'Terkirim' : 'Kirim'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.green.shade100,
                      disabledForegroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _sudahDikirim ? _showStatus : null,
                icon: const Icon(Icons.receipt_long_outlined, size: 18),
                label: const Text('Lihat Status Pengiriman'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
