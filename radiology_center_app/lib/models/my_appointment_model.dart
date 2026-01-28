class MyAppointmentModel {
  final int id;
  final String date;
  final String time;
  final bool isAvailable;

  MyAppointmentModel({
    required this.id,
    required this.date,
    required this.time,
    required this.isAvailable,
  });

  factory MyAppointmentModel.fromJson(Map<String, dynamic> json) {
    return MyAppointmentModel(
      id: json['id'],
      date: json['date'] ?? "",
      time: json['time'] ?? "",
      isAvailable: json['is_available'] ?? false,
    );
  }
}
