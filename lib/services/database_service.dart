import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';
import '../models/test_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> submitAttendance(List<AttendanceRecord> records) async {
    for (var record in records) {
      await _db.collection('attendance').add(record.toMap());
    }
  }

  Future<void> markPresent(String studentId, String studentName) async {
    final record = AttendanceRecord(
      studentId: studentId,
      studentName: studentName,
      isPresent: true,
      date: DateTime.now(),
    );
    await _db.collection('attendance').add(record.toMap());
  }

  Future<List<AttendanceRecord>> fetchAllAttendance() async {
    final snapshot = await _db.collection('attendance').get();
    return snapshot.docs.map((doc) => AttendanceRecord.fromMap(doc.data())).toList();
  }

  Future<void> submitTest(TestResult result) async {
    await _db.collection('testResults').add(result.toMap());
  }

  Future<List<TestResult>> fetchAllResults() async {
    final snapshot = await _db.collection('testResults').get();
    return snapshot.docs.map((doc) => TestResult.fromMap(doc.data())).toList();
  }
}
