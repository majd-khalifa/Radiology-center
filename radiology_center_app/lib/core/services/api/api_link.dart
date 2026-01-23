class ApiLink {
  static const String baseUrl = "http://127.0.0.1:8000/api/";
  static const String logIn = "${baseUrl}accounts/login/";
  static const String register = "${baseUrl}accounts/register/";
  static const String devices = "${baseUrl}radiology/devices/";
  static const String appointments =
      "${baseUrl}radiology/devices/2/appointments/";
  static const String bookAppointment = "${baseUrl}radiology/appointments/38/book/";
}
