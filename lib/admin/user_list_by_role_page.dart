import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListByRolePage extends StatefulWidget {
  @override
  _UserListByRolePageState createState() => _UserListByRolePageState();
}

class _UserListByRolePageState extends State<UserListByRolePage> {
  String selectedRole = 'Student'; // Default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users By Role')),
      body: Column(
        children: [
          // Role selection buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => selectedRole = 'Student'),
                child: Text('Students'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => selectedRole = 'Teacher'),
                child: Text('Teachers'),
              ),
              ElevatedButton(
                onPressed: () => setState(() => selectedRole = 'Manager'),
                child: Text('Managers'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Showing: $selectedRole(s)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),

          // List of users by selected role
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: selectedRole)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return Center(child: Text('No $selectedRole accounts found.'));

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final data = users[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(Icons.email),
                      title: Text(data['email'] ?? 'No Email'),
                      subtitle: Text('Role: ${data['role']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
