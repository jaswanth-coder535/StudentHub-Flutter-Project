import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _storage.addListener(_onStorageChange);
  }

  @override
  void dispose() {
    _storage.removeListener(_onStorageChange);
    super.dispose();
  }

  void _onStorageChange() {
    if (mounted) setState(() {});
  }

  void _showEditProfileDialog() {
    final student = _storage.student;
    final nameController = TextEditingController(text: student.name);
    final rollController = TextEditingController(text: student.rollNumber);
    final emailController = TextEditingController(text: student.email);
    final phoneController = TextEditingController(text: student.phone);
    String selectedDept = student.department;
    String selectedSem = student.semester;

    final departments = [
      'Computer Science & Engineering',
      'Information Technology',
      'Electronics & Communication',
      'Mechanical Engineering',
      'Civil Engineering',
      'Data Science & AI',
    ];

    final semesters = [
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8',
    ];

    if (!departments.contains(selectedDept)) {
      departments.add(selectedDept);
    }
    if (!semesters.contains(selectedSem)) {
      semesters.add(selectedSem);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 24,
                right: 24,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Edit Student Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: rollController,
                      decoration: const InputDecoration(labelText: 'Roll Number'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedDept,
                      decoration: const InputDecoration(labelText: 'Department'),
                      items: departments.map((d) {
                        return DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 13)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedDept = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSem,
                      decoration: const InputDecoration(labelText: 'Semester'),
                      items: semesters.map((s) {
                        return DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedSem = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email Address'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final updated = student.copyWith(
                          name: nameController.text.trim(),
                          rollNumber: rollController.text.trim(),
                          department: selectedDept,
                          semester: selectedSem,
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                        _storage.updateProfile(updated);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      },
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to sign out from Student Hub?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger,
                minimumSize: const Size(90, 40),
              ),
              onPressed: () async {
                final nav = Navigator.of(context);
                nav.pop();
                await _storage.logout();
                nav.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = _storage.student;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryBlue),
            tooltip: 'Edit Profile',
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          children: [
            // Profile Card Header
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppTheme.primaryLightBlue,
                        child: const Icon(Icons.person, size: 54, color: AppTheme.primaryBlue),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showEditProfileDialog,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Roll No: ${student.rollNumber}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    student.department,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _showEditProfileDialog,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit Details'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(140, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Academic Information Section
            const SectionHeader(title: 'Academic Details'),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildProfileRow(Icons.school_outlined, 'Program', 'B.Tech Computer Science'),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _buildProfileRow(Icons.account_tree_outlined, 'Department', student.department),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _buildProfileRow(Icons.calendar_month_outlined, 'Semester', student.semester),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _buildProfileRow(Icons.date_range_outlined, 'Academic Year', student.academicYear),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _buildProfileRow(Icons.verified_user_outlined, 'Student Portal ID', student.id),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contact Information Section
            const SectionHeader(title: 'Contact Information'),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildProfileRow(Icons.email_outlined, 'University Email', student.email),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _buildProfileRow(Icons.phone_outlined, 'Phone Number', student.phone),
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  _buildProfileRow(Icons.location_on_outlined, 'Campus Hostel', 'Hostel Block 3, Room 412'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Settings & Logout
            const SectionHeader(title: 'App & Account'),
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                    title: const Text('About Student Hub', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Version 1.0.0 (Release Build)', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textLight),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Student Hub',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(Icons.school, size: 40, color: AppTheme.primaryBlue),
                        children: const [
                          Text('Modern, attractive, beginner-friendly student portal built using Flutter.'),
                        ],
                      );
                    },
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout, color: AppTheme.danger),
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.danger,
                      ),
                    ),
                    subtitle: const Text('Logout from this device', style: TextStyle(fontSize: 12)),
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
