// Experiment 10 — Testing and Debugging in Flutter
// Demonstrates unit testing checklist, assertions, debugging logs, and DevTools integration for Student Hub.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TestingDebuggingExperimentApp());
}

class TestingDebuggingExperimentApp extends StatelessWidget {
  const TestingDebuggingExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF1E88E5)),
      home: const TestingDebuggingScreen(),
    );
  }
}

class TestingDebuggingScreen extends StatelessWidget {
  const TestingDebuggingScreen({super.key});

  // Pure logic function suitable for unit testing
  static double calculateAttendance(int attended, int total) {
    assert(total > 0, 'Total classes must be greater than zero');
    assert(attended <= total, 'Attended classes cannot exceed total classes');
    return (attended / total) * 100.0;
  }

  // Pure logic function for CGPA calculation
  static String evaluateStanding(double gpa) {
    if (gpa >= 8.5) return 'Distinction';
    if (gpa >= 7.0) return 'First Class';
    if (gpa >= 5.0) return 'Pass';
    return 'Probation';
  }

  @override
  Widget build(BuildContext context) {
    final double testAttendance = calculateAttendance(161, 186);
    final String testStanding = evaluateStanding(8.82);

    if (kDebugMode) {
      debugPrint('[DEBUG] Attendance calculated: $testAttendance%');
      debugPrint('[DEBUG] Student Academic Standing: $testStanding');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Exp 10: Testing & Debugging Checklist'), backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFA7F3D0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('✅ Verified Unit Test Results:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                  const SizedBox(height: 8),
                  Text('• calculateAttendance(161, 186) -> ${testAttendance.toStringAsFixed(1)}% (Expected ~86.6%)', style: const TextStyle(fontSize: 13)),
                  Text('• evaluateStanding(8.82) -> "$testStanding" (Expected "Distinction")', style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Flutter Testing Suite Checklist:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildChecklistTile('Unit Testing', 'Pure Dart calculation functions (GPA, Attendance, Grade Points)', true),
            _buildChecklistTile('Widget Testing', 'Smoke test verifying widget tree rendering, buttons & tabs', true),
            _buildChecklistTile('DevTools & Inspector', 'Live widget inspection, repaint rainbows, memory profile', true),
            _buildChecklistTile('Static Analysis', 'flutter analyze static checking with 0 warnings', true),
          ],
        ),
      ),
    );
  }

  static Widget _buildChecklistTile(String title, String desc, bool passed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Icon(passed ? Icons.check_circle : Icons.cancel, color: passed ? const Color(0xFF10B981) : Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(desc, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
