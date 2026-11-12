import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../services/demo_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';
import '../study_materials/study_materials_screen.dart';
import '../results/results_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final student = storage.student;
    final attendancePct = storage.overallAttendancePercentage;
    final pendingCount = storage.assignmentsList.where((a) => !a.isCompleted).length;

    // Filter today's timetable (Monday demo)
    final todaySlots = DemoData.initialTimetable
        .where((slot) => slot.day == 'Monday')
        .take(3);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 20,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: AppTheme.primaryLightBlue,
              child: Icon(Icons.person, color: AppTheme.primaryBlue, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMedium,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_outlined, color: AppTheme.textDark, size: 26),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications. You are up to date!'),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Highlight Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.primaryDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x401E88E5),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.semester,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.rollNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    student.department,
                    style: const TextStyle(
                      color: Color(0xE5FFFFFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0x22FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickMetric(
                          'Attendance',
                          '${attendancePct.toStringAsFixed(1)}%',
                          Icons.how_to_reg_rounded,
                        ),
                        Container(height: 28, width: 1, color: Colors.white24),
                        _buildQuickMetric(
                          'CGPA',
                          '8.82',
                          Icons.auto_graph_rounded,
                        ),
                        Container(height: 28, width: 1, color: Colors.white24),
                        _buildQuickMetric(
                          'Pending Tasks',
                          '$pendingCount',
                          Icons.assignment_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Quick Access Section
            const SectionHeader(title: 'Quick Access'),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
              children: [
                _buildQuickActionCard(
                  context,
                  title: 'Attendance',
                  icon: Icons.pie_chart_rounded,
                  color: const Color(0xFFE0F2FE),
                  iconColor: const Color(0xFF0284C7),
                  onTap: () => onNavigateTab?.call(1),
                ),
                _buildQuickActionCard(
                  context,
                  title: 'Timetable',
                  icon: Icons.calendar_today_rounded,
                  color: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF2563EB),
                  onTap: () => onNavigateTab?.call(2),
                ),
                _buildQuickActionCard(
                  context,
                  title: 'Assignments',
                  icon: Icons.assignment_rounded,
                  color: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFD97706),
                  badge: pendingCount > 0 ? '$pendingCount' : null,
                  onTap: () => onNavigateTab?.call(3),
                ),
                _buildQuickActionCard(
                  context,
                  title: 'Study Notes',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFFEDE9FE),
                  iconColor: const Color(0xFF7C3AED),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StudyMaterialsScreen()),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  title: 'Results',
                  icon: Icons.military_tech_rounded,
                  color: const Color(0xFFECFDF5),
                  iconColor: const Color(0xFF059669),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResultsScreen()),
                    );
                  },
                ),
                _buildQuickActionCard(
                  context,
                  title: 'My Profile',
                  icon: Icons.person_rounded,
                  color: const Color(0xFFF1F5F9),
                  iconColor: const Color(0xFF475569),
                  onTap: () => onNavigateTab?.call(4),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Today's Timetable Preview
            SectionHeader(
              title: "Today's Schedule (Monday)",
              actionText: 'Full Timetable',
              onActionTap: () => onNavigateTab?.call(2),
            ),
            ...todaySlots.map((slot) {
              return CustomCard(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: slot.type == 'Lab'
                            ? const Color(0x1F0284C7)
                            : AppTheme.primaryLightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        slot.type == 'Lab' ? Icons.biotech_rounded : Icons.menu_book_rounded,
                        color: slot.type == 'Lab' ? AppTheme.accentBlue : AppTheme.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slot.subjectName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppTheme.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.textLight),
                              const SizedBox(width: 4),
                              Text(
                                slot.time,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.room_outlined, size: 13, color: AppTheme.textLight),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  slot.room,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StatusBadge.info(slot.type),
                  ],
                ),
              );
            }),
            const SizedBox(height: 18),

            // Campus Announcement / Notice Board
            const SectionHeader(title: 'Campus Highlights & Notices'),
            CustomCard(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.campaign_rounded, color: Color(0xFF16A34A), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mid-Semester Examinations Timetable',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF166534),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Mid-term evaluation for Sem 5 begins Dec 01, 2026. Hall tickets available on portal next week.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF15803D),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomCard(
              color: const Color(0xFFEFF6FF),
              border: Border.all(color: const Color(0xFFBFDBFE)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.code_rounded, color: Color(0xFF2563EB), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Annual Hackathon 2026 Registrations',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Submit your team proposals for the 36-hour code sprint. Cash prizes up to \$10,000!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1D4ED8),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
