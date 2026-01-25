class ApiLink {
  static const String baseUrl = "http://10.0.2.2:8000/api/";

  // ==================================================
  // =================== Auth =========================
  // ==================================================

  /// POST: login
  static const String login = "${baseUrl}accounts/login/";

  /// POST: register
  static const String register = "${baseUrl}accounts/register/";

  /// POST / PUT: profile setup
  static const String profileSetup = "${baseUrl}accounts/profile/";

  // ==================================================
  // =================== Users ========================
  // ==================================================

  /// GET: get all users
  static const String getAllUsers = "${baseUrl}accounts/users/";

  /// PUT / PATCH: edit user
  static String editUser(int userId) => "${baseUrl}accounts/users/$userId/";

  /// DELETE: delete user
  static String deleteUser(int userId) => "${baseUrl}accounts/users/$userId/";

  // ==================================================
  // ================= Radiology ======================
  // ==================================================

  /// GET: get all devices
  static const String devices = "${baseUrl}radiology/devices/";

  /// POST: create device
  static const String postDevice = "${baseUrl}radiology/devices/";

  /// GET: device appointments
  static String deviceAppointments(int deviceId) =>
      "${baseUrl}radiology/devices/$deviceId/appointments/";

  /// GET: booked appointments
  static const String bookedAppointments =
      "${baseUrl}radiology/booked-appointments/";

  // ==================================================
  // ================= Appointments ===================
  // ==================================================

  /// POST: book appointment
  static String bookAppointment(int appointmentId) =>
      "${baseUrl}radiology/appointments/$appointmentId/book/";

  /// PUT / PATCH: update appointment
  static String updateAppointment(int appointmentId) =>
      "${baseUrl}radiology/appointments/$appointmentId/update/";

  /// DELETE: delete appointment
  static String deleteAppointment(int appointmentId) =>
      "${baseUrl}radiology/appointments/$appointmentId/delete/";
}
