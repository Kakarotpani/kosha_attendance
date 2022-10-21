import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'attendance_model.g.dart';

@HiveType(typeId: 0)
class Attendance extends HiveObject{
  @HiveField(0)
  late int? id;

  @HiveField(1)
  late String? reason;

  @HiveField(2)
  late String? createdAt;

  @HiveField(3)
  late bool? isPresent;
}