import 'dart:io';

class PatientProfileModel {
  String? fullName;
  String? birthDay;
  String? birthMonth;
  String? birthYear;
  String? gender;
  String? description;
  String? contactNumber;
  String? patientEmail;
  String? location;

  File? profileImageFile; // 👈 للإرسال
  String? profileImageUrl; // 👈 للعرض

  PatientProfileModel({
    this.fullName,
    this.birthDay,
    this.birthMonth,
    this.birthYear,
    this.gender,
    this.description,
    this.contactNumber,
    this.patientEmail,
    this.location,
    this.profileImageFile,
    this.profileImageUrl,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      fullName: json['full_name'],
      birthDay: json['birth_day'],
      birthMonth: json['birth_month'],
      birthYear: json['birth_year'],
      gender: json['gender'],
      description: json['description'],
      contactNumber: json['contact_number'],
      patientEmail: json['patient_email'],
      location: json['location'],
      profileImageUrl: json['profile_image'], // 👈 رابط
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "birth_day": birthDay,
      "birth_month": birthMonth,
      "birth_year": birthYear,
      "gender": gender,
      "description": description,
      "contact_number": contactNumber,
      "patient_email": patientEmail,
      "location": location,
      "profile_image": profileImageUrl,
    };
  }
}
