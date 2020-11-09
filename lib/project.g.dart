// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as DateTime,
      fields[5] as DateTime,
      fields[6] as String,
      fields[7] as String,
      monId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.projectName)
      ..writeByte(1)
      ..write(obj.projectDesc)
      ..writeByte(2)
      ..write(obj.projectModule)
      ..writeByte(3)
      ..write(obj.projectAsTo)
      ..writeByte(4)
      ..write(obj.projectAsDate)
      ..writeByte(5)
      ..write(obj.projectECDate)
      ..writeByte(6)
      ..write(obj.projectStatus)
      ..writeByte(7)
      ..write(obj.projectRemarks)
      ..writeByte(8)
      ..write(obj.monId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
