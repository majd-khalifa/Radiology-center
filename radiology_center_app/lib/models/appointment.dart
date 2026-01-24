class AppointmentSlot {
  final int id;
  final String time;
  final String date;
  final bool isAvailable;

  AppointmentSlot({
    required this.id,
    required this.time,
    required this.date,
    required this.isAvailable,
  });

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      id: json['id'] as int,
      time: json['time'] as String,
      date: json['date'] as String,
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'time': time, 'date': date, 'is_available': isAvailable};
  }
}
