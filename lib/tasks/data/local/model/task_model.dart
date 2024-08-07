import 'package:uuid/uuid.dart';

class TaskModel {
  String id = Uuid().v4();
  String title;
  String description;
  DateTime? startDateTime;
  DateTime? stopDateTime;
  bool completed;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.startDateTime,
    this.stopDateTime,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'startDateTime': startDateTime?.toIso8601String(),
      'stopDateTime': stopDateTime?.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 'default-id', // Handle missing id
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'])
          : null,
      stopDateTime: json['stopDateTime'] != null
          ? DateTime.parse(json['stopDateTime'])
          : null,
    );
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, '
        'startDateTime: $startDateTime, stopDateTime: $stopDateTime, '
        'completed: $completed}';
  }
}
