// lib/data/models/slot_model.dart
class SlotModel {
  final int id;
  final DateTime date;
  final String time;
  final bool isAvailable;

  SlotModel({
    required this.id,
    required this.date,
    required this.time,
    required this.isAvailable,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      isAvailable: json['is_available'],
    );
  }
}
