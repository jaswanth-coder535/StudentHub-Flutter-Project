// Experiment 1 — Dart Basics for Student Hub
// Demonstrates: Dart data types, operators, string interpolation, collections, and decision logic.

void main() {
  print('=== Student Hub Academic Evaluation Engine ===');

  // Variables & Primitive Types
  const String studentName = 'Alex Johnson';
  const String rollNumber = '21CS1045';
  const String department = 'Computer Science & Engineering';
  const int semester = 5;

  // Numerical calculations: Attendance and Marks
  int totalClassesConducted = 186;
  int classesAttended = 161;
  int classesAbsent = totalClassesConducted - classesAttended;

  double attendancePercentage = (classesAttended / totalClassesConducted) * 100;

  // Grade point average calculations
  List<int> marks = [90, 93, 84, 87, 89]; // out of 100 for 5 core subjects
  int totalMarksObtained = marks.reduce((a, b) => a + b);
  int maxMarks = marks.length * 100;
  double overallPercentage = (totalMarksObtained / maxMarks) * 100;

  // SGPA approximation (scaled out of 10)
  double sgpa = (overallPercentage / 10.0) + 0.1;

  print('Student: $studentName ($rollNumber)');
  print('Department: $department | Semester: $semester');
  print('Attendance: $classesAttended / $totalClassesConducted classes (${attendancePercentage.toStringAsFixed(1)}%)');
  print('Missed Classes: $classesAbsent');

  // Conditional Logic & Eligibility
  if (attendancePercentage >= 75.0) {
    print('Attendance Status: Safe (Eligible for Final Examinations)');
  } else {
    print('Attendance Status: Shortage Warning (Below 75%)');
  }

  print('Total Marks: $totalMarksObtained / $maxMarks (${overallPercentage.toStringAsFixed(1)}%)');
  print('Semester GPA: ${sgpa.toStringAsFixed(2)} / 10.0');

  if (sgpa >= 8.5) {
    print('Classification: First Class with Distinction (High Honors)');
  } else if (sgpa >= 7.0) {
    print('Classification: First Class');
  } else {
    print('Classification: Pass');
  }
}
