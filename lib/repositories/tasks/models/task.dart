import 'package:task_manager/repositories/tasks/tasks.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.status = TaskStatus.inProcess,
  });

  factory Task.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] as String,
      description: data['description'] as String,
      startDate: DateTime.parse(data['startDate'] as String),
      endDate: DateTime.parse(data['endDate'] as String),
      status: TaskStatus.values.byName(
          data['status'] as String), // Преобразование строки в TaskStatus
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
    };
  }

  TaskStatus determineStatus(DateTime now) {
    if (now.isAfter(endDate)) {
      return TaskStatus.overdued;
    } else {
      return status;
    }
  }
}
