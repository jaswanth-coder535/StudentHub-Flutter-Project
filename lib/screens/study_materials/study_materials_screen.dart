import 'package:flutter/material.dart';
import '../../models/study_material.dart';
import '../../services/demo_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_card.dart';

class StudyMaterialsScreen extends StatefulWidget {
  const StudyMaterialsScreen({super.key});

  @override
  State<StudyMaterialsScreen> createState() => _StudyMaterialsScreenState();
}

class _StudyMaterialsScreenState extends State<StudyMaterialsScreen> {
  String _searchQuery = '';
  String _selectedSubject = 'All';

  final List<String> _subjects = [
    'All',
    'Design & Analysis of Algorithms',
    'Database Management Systems',
    'Computer Networks',
    'Software Engineering',
    'Artificial Intelligence',
    'Cloud Computing & DevOps',
  ];

  void _viewDocument(StudyMaterial material) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.picture_as_pdf, color: Color(0xFFDC2626), size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${material.subject} • ${material.fileSize}',
                              style: const TextStyle(fontSize: 12, color: AppTheme.textMedium),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 12),
                  const Text(
                    'Document Overview & Key Topics',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    material.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Chapter Highlights Included:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 8),
                        Text('• Module 1: Theoretical foundation and standard definitions', style: TextStyle(fontSize: 12, height: 1.4)),
                        Text('• Module 2: Solved example problems & numerical proofs', style: TextStyle(fontSize: 12, height: 1.4)),
                        Text('• Module 3: University previous year question walkthroughs', style: TextStyle(fontSize: 12, height: 1.4)),
                        Text('• Module 4: Quick revision formula cheat sheet', style: TextStyle(fontSize: 12, height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadDocument(material);
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 20),
                    label: Text('Download ${material.fileType} (${material.fileSize})'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _downloadDocument(StudyMaterial material) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text('Downloaded: "${material.title}"')),
          ],
        ),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allMaterials = DemoData.initialMaterials;

    final filtered = allMaterials.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSubject = _selectedSubject == 'All' || item.subject == _selectedSubject;
      return matchesSearch && matchesSubject;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Study Materials & Notes'),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // Search field
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search notes, subjects, or topics...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryBlue),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                // Subject Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _subjects.map((sub) {
                      final isSelected = sub == _selectedSubject;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(sub == 'All' ? 'All Subjects' : sub.split(' ')[0]),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryBlue,
                          backgroundColor: const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textMedium,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? AppTheme.primaryBlue : Colors.transparent),
                          ),
                          showCheckmark: false,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedSubject = sub);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Materials list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 48, color: AppTheme.textLight),
                        SizedBox(height: 12),
                        Text('No study materials match your search', style: TextStyle(color: AppTheme.textMedium)),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.picture_as_pdf_rounded,
                                    color: Color(0xFFDC2626),
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.subject,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            item.fileSize,
                                            style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('•', style: TextStyle(color: AppTheme.textLight)),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Added: ${item.uploadDate}',
                                            style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => _viewDocument(item),
                                  icon: const Icon(Icons.visibility_outlined, size: 16),
                                  label: const Text('View Notes', style: TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(110, 36),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () => _downloadDocument(item),
                                  icon: const Icon(Icons.download, size: 16),
                                  label: const Text('Download', style: TextStyle(fontSize: 12)),
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
}
