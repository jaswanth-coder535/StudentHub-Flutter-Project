// Experiment 7 — Forms, Validation & Error Handling
// Demonstrates form validation with GlobalKey<FormState>, email regex, roll number checks, and SnackBar alerts.

import 'package:flutter/material.dart';

void main() {
  runApp(const FormsValidationExperimentApp());
}

class FormsValidationExperimentApp extends StatelessWidget {
  const FormsValidationExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF1E88E5)),
      home: const StudentRegistrationFormScreen(),
    );
  }
}

class StudentRegistrationFormScreen extends StatefulWidget {
  const StudentRegistrationFormScreen({super.key});

  @override
  State<StudentRegistrationFormScreen> createState() => _StudentRegistrationFormScreenState();
}

class _StudentRegistrationFormScreenState extends State<StudentRegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student "${_nameController.text}" registered successfully!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Exp 7: Forms & Validation'), backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Student Registration Validation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Full Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter student name';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Roll Number Field
              TextFormField(
                controller: _rollController,
                decoration: const InputDecoration(labelText: 'Roll Number (e.g. 21CS1045) *', border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter roll number';
                  if (val.length < 5) return 'Roll number must be at least 5 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // University Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'University Email *', border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter email';
                  if (!val.contains('@') || !val.contains('.')) return 'Enter a valid university email address';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
                onPressed: _submitForm,
                child: const Text('Validate & Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
