import 'package:hive/hive.dart';

part 'settings.g.dart';
//run
// flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: 1)
class Settings  {
  @HiveField(0)
    bool webEnabled;
  Settings(this.webEnabled);

}