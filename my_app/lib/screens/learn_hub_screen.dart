import 'package:flutter/material.dart';

class LearnHubScreen extends StatefulWidget {
  const LearnHubScreen({super.key});

  @override
  State<LearnHubScreen> createState() => _LearnHubScreenState();
}

class _LearnHubScreenState extends State<LearnHubScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Farming Basics',
    'Organic Methods',
    'Pest Control',
    'Harvesting',
    'Marketing',
  ];

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Organic Farming 101',
      'instructor': 'Dr. Sarah Johnson',
      'duration': '2 hours',
      'lessons': 12,
      'level': 'Beginner',
      'rating': 4.8,
    },
    {
      'title': 'Sustainable Agriculture',
      'instructor': 'Prof. Michael Green',
      'duration': '3.5 hours',
      'lessons': 15,
      'level': 'Intermediate',
      'rating': 4.9,
    },
    {
      'title': 'Pest Management Strategies',
      'instructor': 'Emma Watson',
      'duration': '1.5 hours',
      'lessons': 8,
      'level': 'Beginner',
      'rating': 4.7,
    },
    {
      'title': 'Advanced Harvesting Techniques',
      'instructor': 'James Brown',
      'duration': '2.5 hours',
      'lessons': 10,
      'level': 'Advanced',
      'rating': 4.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Hub'),
        backgroundColor: const Color(0xFF1E6F3D),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selectedCategory == category
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: selectedCategory == category
                            ? const Color(0xFF1E6F3D)
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseCard(course);
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(Icons.school, size: 50, color: Colors.grey[600]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E6F3D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        course['level'],
                        style: TextStyle(
                          color: const Color(0xFF1E6F3D),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          course['rating'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  course['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      course['instructor'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.school, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${course['lessons']} lessons',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      course['duration'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showCourseDetails(course);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6F3D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Start Learning'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseDetails(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                course['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(course['instructor']),
                subtitle: const Text('Instructor'),
              ),
              ListTile(
                leading: const Icon(Icons.timer),
                title: Text(course['duration']),
                subtitle: const Text('Duration'),
              ),
              ListTile(
                leading: const Icon(Icons.format_list_numbered),
                title: Text('${course['lessons']} lessons'),
                subtitle: const Text('Total lessons'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Enrolled in ${course['title']}!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F3D),
                  ),
                  child: const Text('Enroll Now'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
