// State provider model for Experiment 5
import 'package:flutter/foundation.dart';

class StudentStateModel extends ChangeNotifier {
  int _attended = 161;
  int _total = 186;
  int _completedAssignments = 2;

  int get attended => _attended;
  int get total => _total;
  int get completedAssignments => _completedAssignments;

  double get attendancePercentage => (_attended / _total) * 100;

  void markPresent() {
    _attended++;
    _total++;
    notifyListeners();
  }

  void markAbsent() {
    _total++;
    notifyListeners();
  }

  void toggleAssignment() {
    _completedAssignments++;
    notifyListeners();
  }
}
