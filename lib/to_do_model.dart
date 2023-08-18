
import 'package:hive/hive.dart';
part 'to_do_model.g.dart';

@HiveType(typeId: 0)
class ToDoModel{
  @HiveField(0)
  String title;
  @HiveField(1)
  String describe;
  @HiveField(2)
  bool isSelected;
  ToDoModel({required this.title, required this.describe, required this.isSelected});
}