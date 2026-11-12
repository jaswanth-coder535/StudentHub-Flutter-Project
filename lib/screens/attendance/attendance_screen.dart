import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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

  void _markPresent(String subjectCode, String subjectName) {
    _storage.markAttendancePresent(subjectCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked Present for $subjectName!'),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _markAbsent(String subjectCode, String subjectName) {
    _storage.markAttendanceAbsent(subjectCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked Absent for $subjectName'),
        backgroundColor: AppTheme.danger,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overallPct = _storage.overallAttendancePercentage;
    final totalConducted = _storage.totalClassesConducted;
    final totalAttended = _storage.totalClassesAttended;
    final totalAbsent = _storage.totalClassesAbsent;
    final list = _storage.attendanceList;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Attendance Overview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Attendance Banner Card
            CustomCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Circular percentage indicator
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: overallPct / 100,
                              strokeWidth: 9,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                overallPct >= 75 ? AppTheme.primaryBlue : AppTheme.danger,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${overallPct.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: overallPct >= 75 ? AppTheme.textDark : AppTheme.danger,
                                  ),
                                ),
                                const Text(
                                  'Overall',
                                  style: TextStyle(fontSize: 10, color: AppTheme.textLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Current Status',
                                  style: TextStyle(fontSize: 12, color: AppTheme.textMedium),
                                ),
                                if (overallPct >= 75)
                                  StatusBadge.success('Safe (≥75%)')
                                else
                                  StatusBadge.danger('Shortage Alert'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Minimum 75% required for examination eligibility.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textLight,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 14, color: AppTheme.primaryBlue),
                                const SizedBox(width: 4),
                                Text(
                                  overallPct >= 75
                                      ? 'You are on track!'
                                      : 'Attend next classes to recover',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28, thickness: 1, color: Color(0xFFF1F5F9)),
                  // Statistics 3-column row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Total Classes', '$totalConducted', AppTheme.textDark),
                      Container(height: 30, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildStatColumn('Attended', '$totalAttended', AppTheme.success),
                      Container(height: 30, width: 1, color: const Color(0xFFE2E8F0)),
                      _buildStatColumn('Absent', '$totalAbsent', AppTheme.danger),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Subject-wise attendance header
            const SectionHeader(
              title: 'Subject-wise Breakdown',
            ),

            // List of subjects
            ...list.map((item) {
              final pct = item.percentage;
              final isSafe = item.isSafe;

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLightBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.subjectCode,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDarkBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.subjectName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Instructor: ${item.professor}',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${pct.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSafe ? AppTheme.primaryBlue : AppTheme.danger,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isSafe)
                              StatusBadge.success('Safe')
                            else
                              StatusBadge.danger('Low Attendance'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: item.totalClasses == 0 ? 0 : item.attendedClasses / item.totalClasses,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isSafe ? AppTheme.primaryBlue : AppTheme.danger,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Details and Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Present: ${item.attendedClasses}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.success,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: AppTheme.textLight)),
                            const SizedBox(width: 8),
                            Text(
                              'Absent: ${item.absentClasses}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.danger,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: AppTheme.textLight)),
                            const SizedBox(width: 8),
                            Text(
                              'Total: ${item.totalClasses}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMedium,
                              ),
                            ),
                          ],
                        ),
                        // Quick demo buttons
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _markPresent(item.subjectCode, item.subjectName),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.successLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, size: 14, color: AppTheme.success),
                                    SizedBox(width: 2),
                                    Text(
                                      'Present',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => _markAbsent(item.subjectCode, item.subjectName),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.dangerLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.remove, size: 14, color: AppTheme.danger),
                                    SizedBox(width: 2),
                                    Text(
                                      'Absent',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.danger,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMedium),
        ),
      ],
    );
  }
}
