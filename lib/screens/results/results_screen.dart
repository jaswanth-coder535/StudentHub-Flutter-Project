import 'package:flutter/material.dart';
import '../../services/demo_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String _selectedSemester = 'Semester 5';

  @override
  Widget build(BuildContext context) {
    final semesterResult = DemoData.semesterResults[_selectedSemester] ??
        DemoData.semesterResults['Semester 5']!;

    final totalObtained = semesterResult.totalMarksObtained;
    final totalMax = semesterResult.totalMaxMarks;
    final percentage = semesterResult.percentage;
    final gpa = semesterResult.gpa;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Examination Results'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Semester Selector Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Semester:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSemester,
                      items: DemoData.semesterResults.keys.map((sem) {
                        return DropdownMenuItem(
                          value: sem,
                          child: Text(
                            sem,
                            style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedSemester = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Performance Summary Card
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
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SEMESTER RESULT',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedSemester,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'PASSED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x22FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem('SGPA', gpa.toStringAsFixed(2), 'Out of 10.0'),
                        Container(height: 32, width: 1, color: Colors.white24),
                        _buildSummaryItem(
                          'Percentage',
                          '${percentage.toStringAsFixed(1)}%',
                          'Calculated',
                        ),
                        Container(height: 32, width: 1, color: Colors.white24),
                        _buildSummaryItem(
                          'Total Marks',
                          '$totalObtained',
                          'Out of $totalMax',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Subject-wise Marks header
            SectionHeader(
              title: 'Subject-wise Marks & Grades',
              actionText: 'Download Memo',
              onActionTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Grade sheet PDF downloaded to device storage.'),
                    backgroundColor: AppTheme.success,
                  ),
                );
              },
            ),

            // Subject marks list
            ...semesterResult.subjects.map((item) {
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
                                    fontSize: 10,
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
                                'Credits: ${item.credits}',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLightBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.grade,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppTheme.primaryDarkBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            StatusBadge.success('Pass'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),

                    // Marks distribution row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMarkBox('Internal (30)', '${item.internalMarks}'),
                        _buildMarkBox('External (70)', '${item.externalMarks}'),
                        _buildMarkBox('Total (100)', '${item.totalMarks}', isHighlight: true),
                        _buildMarkBox('Points', '${item.gradePoint}'),
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

  Widget _buildSummaryItem(String label, String value, String sub) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: const TextStyle(color: Colors.white60, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildMarkBox(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppTheme.textLight),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppTheme.primaryBlue : AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
