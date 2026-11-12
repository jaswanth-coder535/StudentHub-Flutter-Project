class StudyMaterial {
  final String id;
  final String title;
  final String subject;
  final String unit;
  final String fileSize;
  final String uploadDate;
  final String fileType; // PDF, PPT, DOC
  final String description;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.unit,
    required this.fileSize,
    required this.uploadDate,
    required this.fileType,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'unit': unit,
      'fileSize': fileSize,
      'uploadDate': uploadDate,
      'fileType': fileType,
      'description': description,
    };
  }

  factory StudyMaterial.fromMap(Map<String, dynamic> map) {
    return StudyMaterial(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      unit: map['unit'] ?? '',
      fileSize: map['fileSize'] ?? '',
      uploadDate: map['uploadDate'] ?? '',
      fileType: map['fileType'] ?? 'PDF',
      description: map['description'] ?? '',
    );
  }
}
