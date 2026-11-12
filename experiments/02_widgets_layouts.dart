// Experiment 2 — Flutter Widgets & Layouts
// Demonstrates structuring the Student Hub interface using Column, Row, Stack, Container, and Padding.

import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetsLayoutsExperimentApp());
}

class WidgetsLayoutsExperimentApp extends StatelessWidget {
  const WidgetsLayoutsExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF1E88E5),
      ),
      home: const StudentDashboardLayoutScreen(),
    );
  }
}

class StudentDashboardLayoutScreen extends StatelessWidget {
  const StudentDashboardLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exp 2: Widgets & Layouts'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stack Widget: Gradient Student Card with Top Right Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Alex Johnson', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('21CS1045 • Computer Science', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 16),
                      Text('Semester 5 (2026 - 2027)', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Row Widget: Quick Metrics side-by-side
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Attendance', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        SizedBox(height: 6),
                        Text('86.4%', style: TextStyle(color: Color(0xFF1E88E5), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('CGPA', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        SizedBox(height: 6),
                        Text('8.82', style: TextStyle(color: Color(0xFF10B981), fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Column Widget: Vertical Class Schedule Items
            const Text("Today's Schedule Items", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.menu_book, color: Color(0xFF1E88E5)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('CS501: Design & Analysis of Algorithms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                  Text('09:00 AM', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
