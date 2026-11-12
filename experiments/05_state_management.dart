// Experiment 5 — Stateful & Stateless Widgets + Reactive State Management
// Contrasts local setState() with decoupled reactive state management using ChangeNotifier & ListenableBuilder.

import 'package:flutter/material.dart';
import 'student_provider.dart';

void main() {
  runApp(const StateManagementExperimentApp());
}

class StateManagementExperimentApp extends StatelessWidget {
  const StateManagementExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF1E88E5)),
      home: const StateManagementDemoScreen(),
    );
  }
}

class StateManagementDemoScreen extends StatefulWidget {
  const StateManagementDemoScreen({super.key});

  @override
  State<StateManagementDemoScreen> createState() => _StateManagementDemoScreenState();
}

class _StateManagementDemoScreenState extends State<StateManagementDemoScreen> {
  // Local state counter
  int _localStudyHours = 12;

  // Decoupled reactive state model
  final StudentStateModel _studentModel = StudentStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Exp 5: State Management Comparison'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Local State with setState()
            const Text('1. Local State (StatefulWidget + setState)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Weekly Study Hours: $_localStudyHours hrs', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF1E88E5)),
                    onPressed: () => setState(() => _localStudyHours++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Decoupled Reactive State (ChangeNotifier + ListenableBuilder)
            const Text('2. Decoupled Reactive State (ChangeNotifier)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: _studentModel,
              builder: (context, _) {
                final pct = _studentModel.attendancePercentage;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                  child: Column(
                    children: [
                      Text('Live Attendance: ${pct.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                      Text('${_studentModel.attended} attended / ${_studentModel.total} classes', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                            onPressed: () => _studentModel.markPresent(),
                            child: const Text('+ Present'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => _studentModel.markAbsent(),
                            child: const Text('+ Absent'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
