import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/admin/user_list_by_role_page.dart';
import 'subject_detail_page.dart';

class ClassDetailPage extends StatefulWidget {
  final String className;
  ClassDetailPage({required this.className});

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  bool showAll = false;

  final List<String> allSubjects = [
    'Math', 'Science', 'English', 'Urdu', 'Computer',
    'Biology', 'Chemistry', 'Physics', 'History', 'Islamiyat',
    'Economics', 'Civics', 'Geography', 'Social Studies',
    'Programming', 'Robotics', 'Astronomy', 'Philosophy', 'Art'
  ];

  final Map<String, String> courseDetails = {
    'Math': 'Algebra, Geometry, Trigonometry',
    'Science': 'General Science, Experiments',
    'English': 'Grammar, Essays, Comprehension',
    'Urdu': 'Nazm, Ghazal, Essay',
    'Computer': 'Programming, IT Basics',
    'Biology': 'Cell, Human Body, Plants',
    'Chemistry': 'Elements, Compounds, Reactions',
    'Physics': 'Motion, Force, Energy',
    'History': 'World Wars, Subcontinent',
    'Islamiyat': 'Life of Prophet, Quran, Hadith',
    'Economics': 'Microeconomics, Macroeconomics',
    'Civics': 'Government, Constitution',
    'Geography': 'Maps, Climate, Regions',
    'Social Studies': 'Culture, History, Civics',
    'Programming': 'Dart, Python, Java',
    'Robotics': 'Sensors, Motors, Coding',
    'Astronomy': 'Planets, Stars, Universe',
    'Philosophy': 'Logic, Ethics, Metaphysics',
    'Art': 'Drawing, Painting, Sculpture',
  };

  Future<void> showLoginCount(BuildContext context) async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('login_users').get();
      final emails = snapshot.docs.map((doc) => doc['email'] as String).toList();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Logged-in Users: ${emails.length}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: emails.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.email),
                  title: Text(emails[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> displayedSubjects =
    showAll ? allSubjects : allSubjects.take(6).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects - ${widget.className}'),
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          /// Subject List
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayedSubjects.length + 1,
                      itemBuilder: (context, index) {
                        if (index == displayedSubjects.length) {
                          return TextButton(
                            onPressed: () => setState(() => showAll = !showAll),
                            child: Text(showAll ? 'Show Less' : 'Show More'),
                          );
                        }

                        String subject = displayedSubjects[index];
                        return ListTile(
                          title: Text(subject),
                          leading: Icon(Icons.book),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectDetailPage(
                                  subject: subject,
                                  courseContent: courseDetails[subject] ??
                                      'No details available.',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Admin Panel
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blueGrey.shade50,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Panel',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Divider(),

                  for (int i = 1; i <= 5; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.settings),
                        label: Text('Admin Option $i'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Clicked Admin Option $i')),
                          );
                        },
                      ),
                    ),

                  Divider(),
                  SizedBox(height: 10),

                  ElevatedButton.icon(
                    icon: Icon(Icons.analytics),
                    label: Text('View Login Count'),
                    onPressed: () => showLoginCount(context),
                  ),
                  SizedBox(height: 10),

                  ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserListByRolePage()));
                  }, child: Text("Button"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


