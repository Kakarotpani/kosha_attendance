import 'package:flutter/material.dart';
import 'package:kosha_attendance/models/attendance_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kosha_attendance/views/home_view.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AttendanceAdapter());
  await Hive.openBox<Attendance>('attendance');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: const HomeView(title: 'Kosha Attendance'),
    );
  }
}


