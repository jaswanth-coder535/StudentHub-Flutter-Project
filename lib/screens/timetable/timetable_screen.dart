import 'package:flutter/material.dart';
import '../../services/demo_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/status_badge.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  String _selectedDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    final slots = DemoData.initialTimetable
        .where((slot) => slot.day.toLowerCase() == _selectedDay.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Weekly Timetable'),
      ),
      body: Column(
        children: [
          // Day Selector Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _days.map((day) {
                  final isSelected = day == _selectedDay;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(day),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryBlue,
                      backgroundColor: const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textMedium,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                        ),
                      ),
                      showCheckmark: false,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedDay = day);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Header summary for chosen day
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule for $_selectedDay',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  '${slots.length} Classes',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),

          // List of classes for the day
          Expanded(
            child: slots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.event_busy, size: 48, color: AppTheme.textLight),
                        SizedBox(height: 12),
                        Text(
                          'No classes scheduled for this day',
                          style: TextStyle(color: AppTheme.textMedium),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final isLab = slot.type == 'Lab';

                      return CustomCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Period index / Time column
                            Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                              decoration: BoxDecoration(
                                color: isLab
                                    ? const Color(0x180284C7)
                                    : AppTheme.primaryLightBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isLab ? Icons.biotech_outlined : Icons.access_time_rounded,
                                    size: 20,
                                    color: isLab ? AppTheme.accentBlue : AppTheme.primaryBlue,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    slot.time.split(' - ')[0],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isLab ? AppTheme.accentBlue : AppTheme.primaryDarkBlue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'to ${slot.time.split(' - ')[1]}',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.textMedium,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Class details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          slot.subjectCode,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textDark,
                                          ),
                                        ),
                                      ),
                                      StatusBadge.info(slot.type),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    slot.subjectName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline, size: 14, color: AppTheme.textLight),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          slot.instructor,
                                          style: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.meeting_room_outlined, size: 14, color: AppTheme.textLight),
                                      const SizedBox(width: 4),
                                      Text(
                                        slot.room,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
