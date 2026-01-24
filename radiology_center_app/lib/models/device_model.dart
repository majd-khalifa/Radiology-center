class DeviceModel {
  final int? id;
  final String name;
  final String specialty;
  final String description;
  final double rating;

  DeviceModel({
    this.id,
    required this.name,
    required this.specialty,
    required this.description,
    required this.rating,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      description: json['description'] ?? '',
      // تحويل آمن للتقييم لتجنب خطأ toDouble
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "specialty": specialty,
      "description": description,
      "rating": rating,
    };
  }
}
