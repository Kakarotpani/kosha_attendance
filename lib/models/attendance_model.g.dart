part of 'attendance_model.dart';

class AttendanceAdapter extends TypeAdapter<Attendance> {
  @override
  final int typeId = 0;

  @override
  Attendance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attendance()
      ..id = fields[0] as int?
      ..reason = fields[1] as String?
      ..createdAt = fields[2] as String?
      ..isPresent = fields[3] as bool?;
  }

  @override
  void write(BinaryWriter writer, Attendance obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reason)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.isPresent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
