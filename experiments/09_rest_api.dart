// Experiment 9 — REST API & Async Data Handling
// Demonstrates asynchronous data fetching, FutureBuilder, loading spinners, and error retry states in Student Hub.

import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const RestApiExperimentApp());
}

class RestApiExperimentApp extends StatelessWidget {
  const RestApiExperimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primaryColor: const Color(0xFF1E88E5)),
      home: const CampusNoticesApiScreen(),
    );
  }
}

class CampusNoticesApiScreen extends StatefulWidget {
  const CampusNoticesApiScreen({super.key});

  @override
  State<CampusNoticesApiScreen> createState() => _CampusNoticesApiScreenState();
}

class _CampusNoticesApiScreenState extends State<CampusNoticesApiScreen> {
  late Future<List<NoticeItem>> _noticesFuture;

  @override
  void initState() {
    super.initState();
    _noticesFuture = _fetchCampusNotices();
  }

  // Simulated REST API fetch
  Future<List<NoticeItem>> _fetchCampusNotices() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simulated API response JSON
    const String mockJsonResponse = '''
    [
      {"id": 1, "title": "Mid-Semester Examination Dates Released", "category": "Examinations", "date": "Nov 12, 2026"},
      {"id": 2, "title": "Campus Hackathon 2026 Registration Open", "category": "Events", "date": "Nov 15, 2026"},
      {"id": 3, "title": "Central Library Extended Reading Room Hours", "category": "Facilities", "date": "Nov 20, 2026"}
    ]
    ''';

    final List<dynamic> parsedList = json.decode(mockJsonResponse);
    return parsedList.map((item) => NoticeItem.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Exp 9: REST API & FutureBuilder'), backgroundColor: Colors.white, elevation: 0),
      body: FutureBuilder<List<NoticeItem>>(
        future: _noticesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Fetching live campus notices...', style: TextStyle(color: Color(0xFF64748B))),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() => _noticesFuture = _fetchCampusNotices()),
                    child: const Text('Retry Connection'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notices found'));
          }

          final notices = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final n = notices[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(6)),
                          child: Text(n.category, style: const TextStyle(color: Color(0xFF0D47A1), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        Text(n.date, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(n.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NoticeItem {
  final int id;
  final String title;
  final String category;
  final String date;

  NoticeItem({required this.id, required this.title, required this.category, required this.date});

  factory NoticeItem.fromJson(Map<String, dynamic> json) {
    return NoticeItem(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      date: json['date'],
    );
  }
}
