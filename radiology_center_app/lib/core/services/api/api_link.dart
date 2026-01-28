class ApiLink {
  static const String baseUrl = "http://10.0.2.2:8000";

  // ==================================================
  // =================== Auth =========================
  // ==================================================

  /// POST: login
  static const String login = "${baseUrl}/api/accounts/login/";

  /// POST: register
  static const String register = "${baseUrl}/api/accounts/register/";

  /// POST / PUT: profile setup
  static const String profileSetup = "${baseUrl}/api/accounts/profile/";

  // ==================================================
  // =================== Users ========================
  // ==================================================

  /// GET: get all users
  static const String getAllUsers = "${baseUrl}/api/accounts/users/";

  /// PUT / PATCH: edit user
  static String editUser(int userId) =>
      "${baseUrl}/api/accounts/users/$userId/";

  /// DELETE: delete user
  static String deleteUser(int userId) =>
      "${baseUrl}/api/accounts/users/$userId/";

  // ==================================================
  // ================= Radiology ======================
  // ==================================================

  /// GET: get all devices
  static const String devices = "${baseUrl}/api/radiology/devices/";

  /// POST: create device
  static const String postDevice = "${baseUrl}/api/radiology/devices/";

  /// GET: device appointments
  static String deviceAppointments(int deviceId) =>
      "${baseUrl}/api/radiology/devices/$deviceId/appointments/";

  /// GET: booked appointments
  static const String bookedAppointments =
      "${baseUrl}/api/radiology/booked-appointments/";

  /// GET: my appointments for logged-in user
  static const String myAppointments = "${baseUrl}radiology/my-appointments/";

  // ==================================================
  // ================= Appointments ===================
  // ==================================================

  /// POST: book appointment
  static String bookAppointment(int appointmentId) =>
      "${baseUrl}/api/radiology/appointments/$appointmentId/book/";

  /// PUT / PATCH: update appointment
  static String updateAppointment(int appointmentId) =>
      "${baseUrl}/api/radiology/appointments/$appointmentId/update/";

  /// DELETE: delete appointment
  static String deleteAppointment(int appointmentId) =>
      "${baseUrl}/api/radiology/appointments/$appointmentId/delete/";
}
