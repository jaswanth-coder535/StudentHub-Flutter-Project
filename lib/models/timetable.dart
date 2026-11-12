class TimetableSlot {
  final String id;
  final String day; // Monday, Tuesday, etc.
  final String subjectName;
  final String subjectCode;
  final String time; // e.g., 09:00 AM - 10:00 AM
  final String room; // e.g., Room 302, Lab 4
  final String instructor;
  final String type; // Lecture, Lab, Tutorial

  TimetableSlot({
    required this.id,
    required this.day,
    required this.subjectName,
    required this.subjectCode,
    required this.time,
    required this.room,
    required this.instructor,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'day': day,
      'subjectName': subjectName,
      'subjectCode': subjectCode,
      'time': time,
      'room': room,
      'instructor': instructor,
      'type': type,
    };
  }

  factory TimetableSlot.fromMap(Map<String, dynamic> map) {
    return TimetableSlot(
      id: map['id'] ?? '',
      day: map['day'] ?? '',
      subjectName: map['subjectName'] ?? '',
      subjectCode: map['subjectCode'] ?? '',
      time: map['time'] ?? '',
      room: map['room'] ?? '',
      instructor: map['instructor'] ?? '',
      type: map['type'] ?? 'Lecture',
    );
  }
}
