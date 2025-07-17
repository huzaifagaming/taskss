import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/attendance_model.dart';

class AttendanceSheetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Sheet')),
      body: FutureBuilder<List<AttendanceRecord>>(
        future: DatabaseService().fetchAllAttendance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final rec = records[index];
              return ListTile(
                title: Text('${rec.studentName} - ${rec.isPresent ? "Present" : "Absent"}'),
                subtitle: Text('${rec.date.toLocal()}'),
              );
            },
          );
        },
      ),
    );
  }
}
