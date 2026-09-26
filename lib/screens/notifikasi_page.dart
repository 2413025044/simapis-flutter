import 'package:flutter/material.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final List<Map<String, dynamic>> _notifikasi = [
    {
      'judul': 'Pelanggaran Baru',
      'pesan': 'Ahmad Rizky mendapatkan pelanggaran karena tidak menggunakan atribut lengkap.',
      'tanggal': '26 September 2026',
      'waktu': '10:15',
      'tipe': 'Pelanggaran',
      'dibaca': false,
    },
    {
      'judul': 'Absensi Berhasil',
      'pesan': 'Data absensi siswa kelas VII A telah berhasil diperbarui.',
      'tanggal': '26 September 2026',
      'waktu': '08:30',
      'tipe': 'Absensi',
      'dibaca': true,
    },
    {
      'judul': 'Pengumuman Sekolah',
      'pesan': 'Besok seluruh siswa wajib mengikuti kegiatan apel pagi.',
      'tanggal': '25 September 2026',
      'waktu': '15:00',
      'tipe': 'Pengumuman',
      'dibaca': false,
    },
    {
      'judul': 'Laporan Kelas',
      'pesan': 'Laporan absensi kelas VIII A telah tersedia untuk diperiksa.',
      'tanggal': '25 September 2026',
      'waktu': '13:20',
      'tipe': 'Laporan',
      'dibaca': true,
    },
  ];

  String _filter = 'Semua';

  List<Map<String, dynamic>> get _filteredData {
    if (_filter == 'Semua') {
      return _notifikasi;
    }

    if (_filter == 'Belum Dibaca') {
      return _notifikasi.where((item) {
        return item['dibaca'] == false;
      }).toList();
    }

    return _notifikasi.where((item) {
      return item['tipe'] == _filter;
    }).toList();
  }

  int get _belumDibaca {
    return _notifikasi.where((item) => item['dibaca'] == false).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Tandai semua dibaca',
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),

      body: Column(
        children: [
          _buildHeader(),
          _buildFilter(),
          Expanded(
            child: _filteredData.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];

                      return _buildNotificationCard(item);
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        onPressed: _showAddNotification,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pusat Notifikasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$_belumDibaca notifikasi belum dibaca',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FILTER
  // =========================================================

  Widget _buildFilter() {
    final filters = [
      'Semua',
      'Belum Dibaca',
      'Pelanggaran',
      'Absensi',
      'Pengumuman',
      'Laporan',
    ];

    return SizedBox(
      height: 60,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = _filter == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _filter = filter;
              });
            },
            selectedColor: const Color(0xFF1565C0),
            labelStyle: TextStyle(
              color: selected ? Colors.white : const Color(0xFF424242),
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // CARD NOTIFIKASI
  // =========================================================

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    final bool dibaca = item['dibaca'];

    final icon = _getIcon(item['tipe']);

    final iconColor = _getIconColor(item['tipe']);

    return GestureDetector(
      onTap: () {
        _showNotificationDetail(item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: dibaca ? Colors.white : const Color(0xFFEAF3FF),
          borderRadius: BorderRadius.circular(17),
          border: dibaca ? null : Border.all(color: const Color(0xFF90CAF9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['judul'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: dibaca
                                ? FontWeight.w600
                                : FontWeight.bold,
                          ),
                        ),
                      ),

                      if (!dibaca)
                        Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1565C0),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item['pesan'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${item['tanggal']} • ${item['waktu']}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        item['tipe'],
                        style: TextStyle(
                          color: iconColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'read') {
                  _markAsRead(item);
                } else if (value == 'delete') {
                  _deleteNotification(item);
                }
              },
              itemBuilder: (context) {
                return [
                  if (!dibaca)
                    const PopupMenuItem(
                      value: 'read',
                      child: Row(
                        children: [
                          Icon(Icons.done),
                          SizedBox(width: 10),
                          Text('Tandai dibaca'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ICON
  // =========================================================

  IconData _getIcon(String tipe) {
    switch (tipe) {
      case 'Pelanggaran':
        return Icons.warning_amber_rounded;

      case 'Absensi':
        return Icons.fact_check_outlined;

      case 'Pengumuman':
        return Icons.campaign_outlined;

      case 'Laporan':
        return Icons.description_outlined;

      default:
        return Icons.notifications_none;
    }
  }

  Color _getIconColor(String tipe) {
    switch (tipe) {
      case 'Pelanggaran':
        return Colors.red;

      case 'Absensi':
        return Colors.green;

      case 'Pengumuman':
        return Colors.orange;

      case 'Laporan':
        return Colors.blue;

      default:
        return const Color(0xFF1565C0);
    }
  }

  // =========================================================
  // DETAIL NOTIFIKASI
  // =========================================================

  void _showNotificationDetail(Map<String, dynamic> item) {
    _markAsRead(item);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getIconColor(item['tipe']).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(item['tipe']),
                      color: _getIconColor(item['tipe']),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      item['judul'],
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                item['pesan'],
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${item['tanggal']} • ${item['waktu']}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // TAMBAH NOTIFIKASI
  // =========================================================

  void _showAddNotification() {
    final judulController = TextEditingController();
    final pesanController = TextEditingController();

    String tipe = 'Pengumuman';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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

                    const Text(
                      'Buat Notifikasi',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: judulController,
                      decoration: InputDecoration(
                        labelText: 'Judul',
                        hintText: 'Masukkan judul notifikasi',
                        prefixIcon: const Icon(Icons.title),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    DropdownButtonFormField<String>(
                      value: tipe,
                      decoration: InputDecoration(
                        labelText: 'Jenis Notifikasi',
                        prefixIcon: const Icon(Icons.category_outlined),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pengumuman',
                          child: Text('Pengumuman'),
                        ),
                        DropdownMenuItem(
                          value: 'Pelanggaran',
                          child: Text('Pelanggaran'),
                        ),
                        DropdownMenuItem(
                          value: 'Absensi',
                          child: Text('Absensi'),
                        ),
                        DropdownMenuItem(
                          value: 'Laporan',
                          child: Text('Laporan'),
                        ),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          tipe = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    TextField(
                      controller: pesanController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Pesan',
                        hintText: 'Masukkan isi notifikasi',
                        prefixIcon: const Icon(Icons.message_outlined),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Batal'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (judulController.text.trim().isEmpty ||
                                  pesanController.text.trim().isEmpty) {
                                _showMessage('Judul dan pesan wajib diisi.');
                                return;
                              }

                              setState(() {
                                _notifikasi.insert(0, {
                                  'judul': judulController.text.trim(),
                                  'pesan': pesanController.text.trim(),
                                  'tanggal': '26 September 2026',
                                  'waktu': 'Sekarang',
                                  'tipe': tipe,
                                  'dibaca': false,
                                });
                              });

                              Navigator.pop(context);

                              _showMessage('Notifikasi berhasil dibuat');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Kirim'),
                          ),
                        ),
                      ],
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
  // TANDAI DIBACA
  // =========================================================

  void _markAsRead(Map<String, dynamic> item) {
    setState(() {
      item['dibaca'] = true;
    });
  }

  // =========================================================
  // TANDAI SEMUA
  // =========================================================

  void _markAllAsRead() {
    setState(() {
      for (final item in _notifikasi) {
        item['dibaca'] = true;
      }
    });

    _showMessage('Semua notifikasi telah ditandai sebagai dibaca');
  }

  // =========================================================
  // HAPUS
  // =========================================================

  void _deleteNotification(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Notifikasi?'),
          content: const Text('Notifikasi ini akan dihapus dari daftar.'),
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
                  _notifikasi.remove(item);
                });

                Navigator.pop(context);

                _showMessage('Notifikasi berhasil dihapus');
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

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 75, color: Colors.grey.shade400),

          const SizedBox(height: 15),

          const Text(
            'Tidak ada notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 7),

          Text(
            'Belum ada notifikasi pada kategori ini.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
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
