import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import '../models/attendance.dart';
import '../models/assignment.dart';
import 'demo_data.dart';

class StorageService extends ChangeNotifier {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _keyIsLoggedIn = 'studenthub_is_logged_in';
  static const String _keyStudentData = 'studenthub_student_data';
  static const String _keyCompletedAssignments = 'studenthub_completed_assignments';
  static const String _keyAttendanceData = 'studenthub_attendance_data';

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  bool _isLoggedIn = false;
  Student? _currentStudent;
  List<SubjectAttendance> _attendanceList = [];
  List<Assignment> _assignmentsList = [];

  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _isLoggedIn;
  Student get student => _currentStudent ?? DemoData.defaultStudent;
  List<SubjectAttendance> get attendanceList => _attendanceList;
  List<Assignment> get assignmentsList => _assignmentsList;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool(_keyIsLoggedIn) ?? false;

    // Load Student
    final studentJson = _prefs.getString(_keyStudentData);
    if (studentJson != null) {
      try {
        _currentStudent = Student.fromJson(studentJson);
      } catch (e) {
        _currentStudent = DemoData.defaultStudent;
      }
    } else {
      _currentStudent = DemoData.defaultStudent;
    }

    // Load Attendance
    final attendanceJson = _prefs.getString(_keyAttendanceData);
    if (attendanceJson != null) {
      try {
        final List<dynamic> list = json.decode(attendanceJson);
        _attendanceList = list.map((e) => SubjectAttendance.fromMap(e)).toList();
      } catch (e) {
        _attendanceList = DemoData.initialAttendance;
      }
    } else {
      _attendanceList = DemoData.initialAttendance;
    }

    // Load Assignments
    final completedIds = _prefs.getStringList(_keyCompletedAssignments) ?? [];
    _assignmentsList = DemoData.initialAssignments.map((asg) {
      if (completedIds.contains(asg.id)) {
        return Assignment(
          id: asg.id,
          title: asg.title,
          subject: asg.subject,
          dueDate: asg.dueDate,
          description: asg.description,
          isCompleted: true,
          maxMarks: asg.maxMarks,
          professor: asg.professor,
        );
      }
      return asg;
    }).toList();

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    // For demo/beginner simplicity, any valid password (or empty check) works
    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    // If identifier matches student roll or email, or login as default
    _isLoggedIn = true;
    await _prefs.setBool(_keyIsLoggedIn, true);
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String rollNumber,
    required String email,
    required String department,
    required String semester,
    required String phone,
    required String password,
  }) async {
    if (name.trim().isEmpty || rollNumber.trim().isEmpty || email.trim().isEmpty) {
      return false;
    }

    final newStudent = Student(
      id: 'STD-2026-${(rollNumber.hashCode % 9000 + 1000).abs()}',
      name: name.trim(),
      rollNumber: rollNumber.trim(),
      email: email.trim(),
      department: department.trim().isNotEmpty ? department.trim() : 'Computer Science & Engineering',
      semester: semester.trim().isNotEmpty ? semester.trim() : 'Semester 1',
      academicYear: '2026 - 2027',
      phone: phone.trim().isNotEmpty ? phone.trim() : '+1 (555) 000-0000',
    );

    _currentStudent = newStudent;
    _isLoggedIn = true;
    await _prefs.setString(_keyStudentData, newStudent.toJson());
    await _prefs.setBool(_keyIsLoggedIn, true);
    notifyListeners();
    return true;
  }

  Future<void> updateProfile(Student updatedStudent) async {
    _currentStudent = updatedStudent;
    await _prefs.setString(_keyStudentData, updatedStudent.toJson());
    notifyListeners();
  }

  Future<void> toggleAssignmentStatus(String assignmentId) async {
    final index = _assignmentsList.indexWhere((a) => a.id == assignmentId);
    if (index != -1) {
      _assignmentsList[index].isCompleted = !_assignmentsList[index].isCompleted;
      
      final completedIds = _assignmentsList
          .where((a) => a.isCompleted)
          .map((a) => a.id)
          .toList();
      await _prefs.setStringList(_keyCompletedAssignments, completedIds);
      notifyListeners();
    }
  }

  Future<void> markAttendancePresent(String subjectCode) async {
    final index = _attendanceList.indexWhere((a) => a.subjectCode == subjectCode);
    if (index != -1) {
      final item = _attendanceList[index];
      _attendanceList[index] = SubjectAttendance(
        subjectCode: item.subjectCode,
        subjectName: item.subjectName,
        totalClasses: item.totalClasses + 1,
        attendedClasses: item.attendedClasses + 1,
        professor: item.professor,
      );

      final jsonString = json.encode(_attendanceList.map((e) => e.toMap()).toList());
      await _prefs.setString(_keyAttendanceData, jsonString);
      notifyListeners();
    }
  }

  Future<void> markAttendanceAbsent(String subjectCode) async {
    final index = _attendanceList.indexWhere((a) => a.subjectCode == subjectCode);
    if (index != -1) {
      final item = _attendanceList[index];
      _attendanceList[index] = SubjectAttendance(
        subjectCode: item.subjectCode,
        subjectName: item.subjectName,
        totalClasses: item.totalClasses + 1,
        attendedClasses: item.attendedClasses,
        professor: item.professor,
      );

      final jsonString = json.encode(_attendanceList.map((e) => e.toMap()).toList());
      await _prefs.setString(_keyAttendanceData, jsonString);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _prefs.setBool(_keyIsLoggedIn, false);
    notifyListeners();
  }

  // Attendance metrics
  int get totalClassesConducted =>
      _attendanceList.fold(0, (sum, a) => sum + a.totalClasses);

  int get totalClassesAttended =>
      _attendanceList.fold(0, (sum, a) => sum + a.attendedClasses);

  int get totalClassesAbsent =>
      totalClassesConducted - totalClassesAttended;

  double get overallAttendancePercentage =>
      totalClassesConducted == 0
          ? 0.0
          : (totalClassesAttended / totalClassesConducted) * 100;
}
