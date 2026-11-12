// Experiment 3 — Responsive UI
// Demonstrates using MediaQuery and responsive breakpoints to adapt Student Hub between mobile and tablet/desktop layouts.

import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveUIExperimentApp());
}

class ResponsiveUIExperimentApp extends StatelessWidget {
  const ResponsiveUIExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF1E88E5)),
      home: const ResponsiveStudentPortalScreen(),
    );
  }
}

class ResponsiveStudentPortalScreen extends StatelessWidget {
  const ResponsiveStudentPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth >= 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Exp 3: Responsive UI (${screenWidth.toInt()}px - ${isTabletOrDesktop ? "Desktop/Tablet" : "Mobile"})'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: isTabletOrDesktop
          // Dual-Pane Layout for Tablet / Desktop
          ? Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: _buildStudentSummary(),
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildAttendanceAndScheduleList(),
                  ),
                ),
              ],
            )
          // Single-Column Layout for Mobile
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStudentSummary(),
                  const SizedBox(height: 16),
                  _buildAttendanceAndScheduleList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStudentSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E88E5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Alex Johnson', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Roll No: 21CS1045 • Semester 5', style: TextStyle(color: Colors.white70, fontSize: 13)),
          SizedBox(height: 12),
          Text('Overall Attendance: 86.4% (Safe)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildAttendanceAndScheduleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subject Breakdown (Adaptive Layout)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        ...['Algorithms (88.9%)', 'Database Systems (91.2%)', 'Computer Networks (86.7%)'].map(
          (sub) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(sub, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
