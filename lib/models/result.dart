class SubjectResult {
  final String subjectCode;
  final String subjectName;
  final int internalMarks;
  final int externalMarks;
  final int maxMarks;
  final String grade;
  final double gradePoint;
  final int credits;

  SubjectResult({
    required this.subjectCode,
    required this.subjectName,
    required this.internalMarks,
    required this.externalMarks,
    this.maxMarks = 100,
    required this.grade,
    required this.gradePoint,
    required this.credits,
  });

  int get totalMarks => internalMarks + externalMarks;
  bool get isPassed => totalMarks >= 40;

  Map<String, dynamic> toMap() {
    return {
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'internalMarks': internalMarks,
      'externalMarks': externalMarks,
      'maxMarks': maxMarks,
      'grade': grade,
      'gradePoint': gradePoint,
      'credits': credits,
    };
  }

  factory SubjectResult.fromMap(Map<String, dynamic> map) {
    return SubjectResult(
      subjectCode: map['subjectCode'] ?? '',
      subjectName: map['subjectName'] ?? '',
      internalMarks: map['internalMarks']?.toInt() ?? 0,
      externalMarks: map['externalMarks']?.toInt() ?? 0,
      maxMarks: map['maxMarks']?.toInt() ?? 100,
      grade: map['grade'] ?? '',
      gradePoint: (map['gradePoint'] as num?)?.toDouble() ?? 0.0,
      credits: map['credits']?.toInt() ?? 3,
    );
  }
}

class SemesterResult {
  final String semester;
  final double gpa;
  final List<SubjectResult> subjects;

  SemesterResult({
    required this.semester,
    required this.gpa,
    required this.subjects,
  });

  int get totalMarksObtained =>
      subjects.fold(0, (sum, item) => sum + item.totalMarks);

  int get totalMaxMarks =>
      subjects.fold(0, (sum, item) => sum + item.maxMarks);

  double get percentage =>
      totalMaxMarks == 0 ? 0.0 : (totalMarksObtained / totalMaxMarks) * 100;
}
