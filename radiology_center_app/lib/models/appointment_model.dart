// lib/data/models/appointment_model.dart
class AppointmentModel {
  final int appointmentId;
  final String date;
  final String time;
  final String bookedByName;
  final String bookedByEmail;

  AppointmentModel({
    required this.appointmentId,
    required this.date,
    required this.time,
    required this.bookedByName,
    required this.bookedByEmail,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointment_id'], // مفتاح الـ ID في Postman
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      // الوصول لبيانات المستخدم المحجوز باسمه من داخل كائن booked_by
      bookedByName: json['booked_by']?['username'] ?? "username",
      bookedByEmail: json['booked_by']?['email'] ?? "",
    );
  }
}
