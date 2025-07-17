class TestResult {
  final String studentId;
  final String studentName;
  final String subject;
  final double marks;
  final DateTime date;

  TestResult({
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.marks,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'subject': subject,
      'marks': marks,
      'date': date.toIso8601String(),
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      studentId: map['studentId'],
      studentName: map['studentName'],
      subject: map['subject'],
      marks: map['marks'],
      date: DateTime.parse(map['date']),
    );
  }
}
