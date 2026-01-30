// lib/data/models/appointment_model.dart
class AppointmentModel {
  final int id;
  final String date;
  final String time;
  final String bookedByName;
  final String bookedByEmail;

  AppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    required this.bookedByName,
    required this.bookedByEmail,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['appointment_id'] ?? json['id'] ?? 0,
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      bookedByName:
          json['booked_by']?['name'] ??
          json['booked_by']?['username'] ??
          "Unknown",
      bookedByEmail: json['booked_by']?['email'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"date": date, "time": time};
  }

  AppointmentModel copyWith({
    int? id,
    String? date,
    String? time,
    String? bookedByName,
    String? bookedByEmail,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      bookedByName: bookedByName ?? this.bookedByName,
      bookedByEmail: bookedByEmail ?? this.bookedByEmail,
    );
  }
}
