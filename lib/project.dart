import 'package:hive/hive.dart';

part 'project.g.dart';
//run
// flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 0)
class Project  {
  @HiveField(0)
    String projectName;
  @HiveField(1)
    String projectDesc;
  @HiveField(2)
    String projectModule;
  @HiveField(3)
    String projectAsTo;
  @HiveField(4)
    DateTime projectAsDate;
  @HiveField(5)
    DateTime projectECDate;
  @HiveField(6)
    String projectStatus;
  @HiveField(7)
    String projectRemarks;
  @HiveField(8)
  String monId;
  Project(this.projectName,this.projectDesc,this.projectModule,this.projectAsTo,this.projectAsDate,this.projectECDate
      ,this.projectStatus,this.projectRemarks,{this.monId});
}