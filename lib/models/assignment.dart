class Assignment {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final String description;
  bool isCompleted;
  final int maxMarks;
  final String professor;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.description,
    this.isCompleted = false,
    this.maxMarks = 20,
    required this.professor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'dueDate': dueDate,
      'description': description,
      'isCompleted': isCompleted,
      'maxMarks': maxMarks,
      'professor': professor,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      dueDate: map['dueDate'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      maxMarks: map['maxMarks']?.toInt() ?? 20,
      professor: map['professor'] ?? '',
    );
  }
}
