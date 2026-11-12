import 'dart:convert';

class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String email;
  final String department;
  final String semester;
  final String academicYear;
  final String phone;
  final String avatarUrl;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.email,
    required this.department,
    required this.semester,
    required this.academicYear,
    required this.phone,
    this.avatarUrl = '',
  });

  Student copyWith({
    String? id,
    String? name,
    String? rollNumber,
    String? email,
    String? department,
    String? semester,
    String? academicYear,
    String? phone,
    String? avatarUrl,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      email: email ?? this.email,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rollNumber': rollNumber,
      'email': email,
      'department': department,
      'semester': semester,
      'academicYear': academicYear,
      'phone': phone,
      'avatarUrl': avatarUrl,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      rollNumber: map['rollNumber'] ?? '',
      email: map['email'] ?? '',
      department: map['department'] ?? '',
      semester: map['semester'] ?? '',
      academicYear: map['academicYear'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));
}
