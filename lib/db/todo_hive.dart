import 'package:hive/hive.dart';

part 'todo_hive.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
  });
}