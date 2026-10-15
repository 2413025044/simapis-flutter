Sistem Informasi Manajemen Absensi dan Pelanggaran Siswa

Deskripsi
SIMAPIS Flutter merupakan aplikasi mobile yang dirancang untuk mendukung pengelolaan informasi absensi dan pelanggaran siswa di lingkungan sekolah. Aplikasi ini dikembangkan menggunakan Flutter dan bahasa pemrograman Dart dengan tampilan antarmuka yang dirancang agar mudah digunakan.
Proyek ini berfokus pada pengembangan prototype aplikasi mobile dengan navigasi yang terstruktur, tampilan informatif, dan pengelompokan fitur sesuai kebutuhan pengguna.

Tujuan Pengembangan
Mengembangkan aplikasi mobile untuk mendukung pengelolaan informasi siswa.
Menerapkan konsep pemrograman mobile menggunakan Flutter dan Dart.
Membangun antarmuka aplikasi yang konsisten dan mudah dipahami.
Menerapkan navigasi ant halaman serta pengorganisasian kode berdasarkan fungsi masing-masing.

Fitur Aplikasi
SIMAPIS Flutter memiliki beberapa menu utama yang mendukung kebutuhan pengelolaan informasi siswa, yaitu:
Login: halaman autentikasi pengguna.
Dashboard: menampilkan ringkasan informasi dan akses ke menu utama.
Absensi: menu pengelolaan dan pengiriman data kehadiran.
Riwayat Absensi: menu untuk melihat informasi kehadiran.
Riwayat Pelanggaran: menu informasi pelanggaran siswa.
Tata Tertib: menampilkan informasi aturan sekolah.
Notifikasi: menyediakan menu informasi pemberitahuan.
Profil: menampilkan informasi profil pengguna.

Teknologi yang Digunakan
Flutter
Dart
Visual Studio Code
Git dan GitHub

Struktur Proyek
lib/
├── screens/
│   ├── dashboard_page.dart
│   ├── login_page.dart
│   ├── kirim_kehadiran_page.dart
│   ├── notifikasi_page.dart
│   ├── pelanggaran_page.dart
│   ├── tata_tertib_page.dart
│   └── profil_page.dart
└── main.dart


Cara Menjalankan Proyek
Pastikan Flutter SDK dan perangkat emulator atau Android sudah tersedia.
Clone repositori SIMAPIS Flutter.
Buka folder proyek menggunakan Visual Studio Code.
Jalankan perintah berikut pada terminal:
flutter pub get
flutter run
