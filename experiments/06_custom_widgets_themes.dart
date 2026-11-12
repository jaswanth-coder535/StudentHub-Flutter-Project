// Experiment 6 — Custom Widgets & Global Themes
// Demonstrates building modular reusable components (StatCard, CustomBadge) and styling with ThemeData.

import 'package:flutter/material.dart';

void main() {
  runApp(const CustomWidgetsThemesExperimentApp());
}

class CustomWidgetsThemesExperimentApp extends StatelessWidget {
  const CustomWidgetsThemesExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1E88E5),
          secondary: Color(0xFF0284C7),
          surface: Colors.white,
        ),
      ),
      home: const CustomWidgetsDemoScreen(),
    );
  }
}

class CustomWidgetsDemoScreen extends StatelessWidget {
  const CustomWidgetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exp 6: Custom Widgets & Themes'), backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reusable Custom Stat Cards:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: ReusableMetricCard(title: 'Attendance', value: '86.4%', icon: Icons.how_to_reg, color: Color(0xFF1E88E5))),
                SizedBox(width: 12),
                Expanded(child: ReusableMetricCard(title: 'CGPA', value: '8.82', icon: Icons.star, color: Color(0xFF10B981))),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Reusable Custom Status Badges:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: const [
                ReusablePillBadge(label: 'Safe (≥75%)', bg: Color(0xFFD1FAE5), text: Color(0xFF065F46)),
                ReusablePillBadge(label: 'Pending Assignment', bg: Color(0xFFFEF3C7), text: Color(0xFF92400E)),
                ReusablePillBadge(label: 'Shortage Warning', bg: Color(0xFFFEE2E2), text: Color(0xFF991B1B)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ReusableMetricCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ReusablePillBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color text;

  const ReusablePillBadge({super.key, required this.label, required this.bg, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
