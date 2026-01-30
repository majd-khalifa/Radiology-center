class DeviceModel {
  final int id;
  final String name;
  final String specialty;
  final String description;
  final double rating;

  DeviceModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.description,
    required this.rating,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      description: json['description'] ?? '',
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

  DeviceModel copyWith({
    int? id,
    String? name,
    String? specialty,
    String? description,
    double? rating,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      description: description ?? this.description,
      rating: rating ?? this.rating,
    );
  }
}
