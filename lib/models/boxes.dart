import 'package:hive_flutter/hive_flutter.dart';
import 'package:kosha_attendance/models/attendance_model.dart';

class Boxes {
  static Box<Attendance> getAttendance() => Hive.box<Attendance>('attendance');
}