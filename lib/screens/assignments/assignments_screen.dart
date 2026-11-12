import 'package:flutter/material.dart';
import '../../models/assignment.dart';
import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/status_badge.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final StorageService _storage = StorageService();
  String _selectedFilter = 'All'; // All, Pending, Completed

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

  void _toggleAssignment(Assignment assignment) {
    _storage.toggleAssignmentStatus(assignment.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          assignment.isCompleted
              ? 'Marked as Completed! 🎉'
              : 'Marked as Pending',
        ),
        backgroundColor: assignment.isCompleted ? AppTheme.success : AppTheme.warning,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAssignmentDetails(Assignment assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      assignment.subject,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDarkBlue,
                      ),
                    ),
                  ),
                  if (assignment.isCompleted)
                    StatusBadge.success('Completed')
                  else
                    StatusBadge.warning('Pending'),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                assignment.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppTheme.textLight),
                  const SizedBox(width: 6),
                  Text(
                    'Due Date: ${assignment.dueDate}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.danger,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.star_border, size: 16, color: AppTheme.textLight),
                  const SizedBox(width: 4),
                  Text(
                    '${assignment.maxMarks} Marks',
                    style: const TextStyle(fontSize: 13, color: AppTheme.textMedium),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Instructions & Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                assignment.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMedium,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Faculty: ${assignment.professor}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _toggleAssignment(assignment);
                      },
                      icon: Icon(
                        assignment.isCompleted ? Icons.undo : Icons.check_circle_outline,
                        size: 18,
                      ),
                      label: Text(
                        assignment.isCompleted ? 'Mark Pending' : 'Mark Done',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (!assignment.isCompleted) {
                          _storage.toggleAssignmentStatus(assignment.id);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('File submitted successfully to portal!'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: const Text('Submit Work', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showAddAssignmentDialog() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final dateController = TextEditingController(text: 'Nov 30, 2026');
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Personal Task / Assignment', style: TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task Title', hintText: 'e.g. Read Chapter 4'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'Subject', hintText: 'e.g. Computer Networks'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Due Date', hintText: 'e.g. Nov 30, 2026'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Notes / Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(100, 42)),
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final newAsg = Assignment(
                    id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleController.text.trim(),
                    subject: subjectController.text.trim().isNotEmpty
                        ? subjectController.text.trim()
                        : 'General Academic',
                    dueDate: dateController.text.trim(),
                    description: descController.text.trim().isNotEmpty
                        ? descController.text.trim()
                        : 'Self-study task',
                    isCompleted: false,
                    maxMarks: 10,
                    professor: 'Self Track',
                  );
                  _storage.assignmentsList.insert(0, newAsg);
                  setState(() {});
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Assignment added successfully!'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allAssignments = _storage.assignmentsList;
    final pendingAssignments = allAssignments.where((a) => !a.isCompleted).toList();
    final completedAssignments = allAssignments.where((a) => a.isCompleted).toList();

    List<Assignment> filtered;
    if (_selectedFilter == 'Pending') {
      filtered = pendingAssignments;
    } else if (_selectedFilter == 'Completed') {
      filtered = completedAssignments;
    } else {
      filtered = allAssignments;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Assignments & Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded, color: AppTheme.primaryBlue),
            tooltip: 'Add Assignment',
            onPressed: _showAddAssignmentDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('All', allAssignments.length),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', pendingAssignments.length),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', completedAssignments.length),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // List of assignments
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.assignment_turned_in_outlined, size: 50, color: AppTheme.textLight),
                        SizedBox(height: 12),
                        Text(
                          'No assignments in this section',
                          style: TextStyle(color: AppTheme.textMedium),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];

                      return CustomCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        onTap: () => _showAssignmentDetails(item),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryLightBlue,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.subject,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryDarkBlue,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (item.isCompleted)
                                  StatusBadge.success('Completed')
                                else
                                  StatusBadge.warning('Pending'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMedium,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 14, color: AppTheme.danger),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Due: ${item.dueDate}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.danger,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: item.isCompleted,
                                      activeColor: AppTheme.primaryBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (val) => _toggleAssignment(item),
                                    ),
                                    Text(
                                      item.isCompleted ? 'Done' : 'Mark Done',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: item.isCompleted ? AppTheme.success : AppTheme.textMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryBlue : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            '$label ($count)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppTheme.textMedium,
            ),
          ),
        ),
      ),
    );
  }
}
