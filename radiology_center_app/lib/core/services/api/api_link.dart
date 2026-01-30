// ignore_for_file: unnecessary_brace_in_string_interps

class ApiLink {
  static const String baseUrl = "http://192.168.1.5:8000";

  // ==================================================
  // =================== Auth =========================
  // ==================================================

  static const String login = "$baseUrl/api/accounts/login/";
  static const String register = "$baseUrl/api/accounts/register/";
  static const String profileSetup = "$baseUrl/api/accounts/profile/";

  // ==================================================
  // =================== Users ========================
  // ==================================================

  static const String getAllUsers = "$baseUrl/api/accounts/users/";

  static String getUser(int userId) => "$baseUrl/api/accounts/users/$userId/";

  static String createUser = "$baseUrl/api/accounts/users/";

  static String editUser(int userId) => "$baseUrl/api/accounts/users/$userId/";

  static String deleteUser(int userId) =>
      "$baseUrl/api/accounts/users/$userId/";

  // ==================================================
  // ================= Radiology ======================
  // ==================================================

  static const String devices = "$baseUrl/api/radiology/devices/";

  static const String postDevice = "$baseUrl/api/radiology/devices/";

  static String getDeviceById(int deviceId) =>
      "$baseUrl/api/radiology/devices/$deviceId/";

  static String updateDevice(int deviceId) =>
      "$baseUrl/api/radiology/devices/$deviceId/";

  static String deleteDevice(int deviceId) =>
      "$baseUrl/api/radiology/devices/$deviceId/";

  static String deviceAppointments(int deviceId) =>
      "$baseUrl/api/radiology/devices/$deviceId/appointments/";

  // ==================================================
  // ================= Appointments ===================
  // ==================================================

  static const String allAppointments = "$baseUrl/api/radiology/appointments/";

  static const String bookedAppointments =
      "$baseUrl/api/radiology/booked-appointments/";

  static const String myAppointments =
      "$baseUrl/api/radiology/my-appointments/";

  static String createAppointment = "$baseUrl/api/radiology/appointments/";

  static String bookAppointment(int appointmentId) =>
      "$baseUrl/api/radiology/appointments/$appointmentId/book/";

  static String updateAppointment(int appointmentId) =>
      "$baseUrl/api/radiology/appointments/$appointmentId/update/";

  static String deleteAppointment(int appointmentId) =>
      "$baseUrl/api/radiology/appointments/$appointmentId/delete/";

  // ==================================================
  // ================= X-ray Analysis =================
  // ==================================================

  static const String analyzeXray = "$baseUrl/analyze-xray";

  static String adminCreateAppointment =
      "$baseUrl/api/radiology/appointments/create/";

  static String adminUpdateAppointment(int id) =>
      "$baseUrl/api/radiology/appointments/$id/admin-update/";

  static String adminDeleteAppointment(int id) =>
      "$baseUrl/api/radiology/appointments/$id/admin-delete/";
}
