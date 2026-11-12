class SubjectAttendance {
  final String subjectCode;
  final String subjectName;
  final int totalClasses;
  int attendedClasses;
  final String professor;

  SubjectAttendance({
    required this.subjectCode,
    required this.subjectName,
    required this.totalClasses,
    required this.attendedClasses,
    required this.professor,
  });

  int get absentClasses => totalClasses - attendedClasses;

  double get percentage =>
      totalClasses == 0 ? 0.0 : (attendedClasses / totalClasses) * 100;

  bool get isSafe => percentage >= 75.0;

  Map<String, dynamic> toMap() {
    return {
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'professor': professor,
    };
  }

  factory SubjectAttendance.fromMap(Map<String, dynamic> map) {
    return SubjectAttendance(
      subjectCode: map['subjectCode'] ?? '',
      subjectName: map['subjectName'] ?? '',
      totalClasses: map['totalClasses']?.toInt() ?? 0,
      attendedClasses: map['attendedClasses']?.toInt() ?? 0,
      professor: map['professor'] ?? '',
    );
  }
}
