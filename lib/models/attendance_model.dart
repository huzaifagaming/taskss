class AttendanceRecord {
  final String studentId;
  final String studentName;
  final bool isPresent;
  final DateTime date;

  AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.isPresent,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'isPresent': isPresent,
      'date': date.toIso8601String(),
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      studentId: map['studentId'],
      studentName: map['studentName'],
      isPresent: map['isPresent'],
      date: DateTime.parse(map['date']),
    );
  }
}
