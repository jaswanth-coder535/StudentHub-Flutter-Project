import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../main_navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedDepartment = 'Computer Science & Engineering';
  String _selectedSemester = 'Semester 5';
  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<String> _departments = [
    'Computer Science & Engineering',
    'Information Technology',
    'Electronics & Communication',
    'Mechanical Engineering',
    'Civil Engineering',
    'Data Science & AI',
  ];

  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    final success = await StorageService().register(
      name: _nameController.text,
      rollNumber: _rollController.text,
      email: _emailController.text,
      department: _selectedDepartment,
      semester: _selectedSemester,
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account registered successfully! Welcome to Student Hub.'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Student Registration'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join Student Hub',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Create your student profile to access timetable, attendance, marks and study materials.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 24),

                // Full Name
                const Text('Full Name *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Alex Johnson',
                    prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.primaryBlue),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your full name' : null,
                ),
                const SizedBox(height: 16),

                // Roll Number
                const Text('Roll / Student Number *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _rollController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 21CS1045',
                    prefixIcon: Icon(Icons.numbers, color: AppTheme.primaryBlue),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your roll number' : null,
                ),
                const SizedBox(height: 16),

                // Department Dropdown
                const Text('Department *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_tree_outlined, color: AppTheme.primaryBlue),
                  ),
                  items: _departments.map((dept) {
                    return DropdownMenuItem(value: dept, child: Text(dept, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDepartment = val);
                  },
                ),
                const SizedBox(height: 16),

                // Semester Dropdown
                const Text('Current Semester *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSemester,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined, color: AppTheme.primaryBlue),
                  ),
                  items: _semesters.map((sem) {
                    return DropdownMenuItem(value: sem, child: Text(sem, style: const TextStyle(fontSize: 14)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSemester = val);
                  },
                ),
                const SizedBox(height: 16),

                // Email
                const Text('University Email Address *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'e.g. alex@studenthub.edu',
                    prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryBlue),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'e.g. +1 (555) 234-5678',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryBlue),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                const Text('Password *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Create a password (min 6 characters)',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primaryBlue),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Complete Registration'),
                ),
                const SizedBox(height: 16),

                // Already registered
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already registered? ', style: TextStyle(color: AppTheme.textMedium)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Back to Sign In',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
