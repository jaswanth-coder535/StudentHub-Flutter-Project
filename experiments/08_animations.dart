// Experiment 8 — Animations in Flutter
// Demonstrates AnimationController, CurvedAnimation, FadeTransition, and ScaleTransition for card reveals.

import 'package:flutter/material.dart';

void main() {
  runApp(const AnimationsExperimentApp());
}

class AnimationsExperimentApp extends StatelessWidget {
  const AnimationsExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF1E88E5)),
      home: const StudentAnimationDemoScreen(),
    );
  }
}

class StudentAnimationDemoScreen extends StatefulWidget {
  const StudentAnimationDemoScreen({super.key});

  @override
  State<StudentAnimationDemoScreen> createState() => _StudentAnimationDemoScreenState();
}

class _StudentAnimationDemoScreenState extends State<StudentAnimationDemoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Exp 8: Flutter Animations'), backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Color(0x331E88E5), blurRadius: 16, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.workspace_premium, color: Colors.white, size: 48),
                        SizedBox(height: 12),
                        Text('Semester 5 Honors Result', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('SGPA: 8.82 / 10.0 (Distinction)', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
                icon: const Icon(Icons.replay),
                label: const Text('Replay Entrance Animation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
