class SimapisSession {
  SimapisSession._();

  static String currentRole = '';
  static String currentUsername = '';

  static bool get isAdmin => currentRole.toLowerCase() == 'admin';

  static bool get isGuru => currentRole.toLowerCase() == 'guru';

  static bool get isSiswa => currentRole.toLowerCase() == 'siswa';

  static bool get canManageMasterData => isAdmin;

  static bool get canManageAttendance => isAdmin || isGuru;

  static bool get canManageDiscipline => isAdmin || isGuru;

  static bool get canManageNotifications => isAdmin || isGuru;

  static void login({required String username, required String role}) {
    currentUsername = username.trim();
    currentRole = role.trim();
  }

  static void logout() {
    currentUsername = '';
    currentRole = '';
  }
}
