// Experiment 4 — Navigation & Named Routes
// Demonstrates multi-screen routing in Student Hub using Navigator.pushNamed() and MaterialPageRoute.

import 'package:flutter/material.dart';

void main() {
  runApp(const NavigationNamedRoutesExperimentApp());
}

class NavigationNamedRoutesExperimentApp extends StatelessWidget {
  const NavigationNamedRoutesExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreenRoute(),
        '/attendance': (context) => const AttendanceScreenRoute(),
        '/results': (context) => const ResultsScreenRoute(),
      },
    );
  }
}

class HomeScreenRoute extends StatelessWidget {
  const HomeScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exp 4: Home Portal (Route: /)'), backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 64, color: Color(0xFF1E88E5)),
              const SizedBox(height: 16),
              const Text('Student Hub Named Navigation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/attendance'),
                icon: const Icon(Icons.pie_chart),
                label: const Text('Go to Attendance (/attendance)'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/results'),
                icon: const Icon(Icons.military_tech),
                label: const Text('Go to Results (/results)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceScreenRoute extends StatelessWidget {
  const AttendanceScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Route (/attendance)'), backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Overall Attendance: 86.4%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Home')),
          ],
        ),
      ),
    );
  }
}

class ResultsScreenRoute extends StatelessWidget {
  const ResultsScreenRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results Route (/results)'), backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Semester 5 SGPA: 8.82 / 10.0', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Home')),
          ],
        ),
      ),
    );
  }
}
