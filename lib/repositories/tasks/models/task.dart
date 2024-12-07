import 'package:task_manager/repositories/tasks/tasks.dart';

/// Класс, представляющий задачу в системе.
class Task {
  /// Уникальный идентификатор задачи.
  final String id;

  /// Название задачи.
  final String title;

  /// Описание задачи.
  final String description;

  /// Дата и время начала выполнения задачи.
  final DateTime startDate;

  /// Дата и время завершения задачи.
  final DateTime endDate;

  /// Статус задачи, по умолчанию - в процессе.
  final TaskStatus status;

  /// Конструктор для создания объекта задачи.
  /// 
  /// [id] - уникальный идентификатор задачи.
  /// [title] - название задачи.
  /// [description] - описание задачи.
  /// [startDate] - дата и время начала выполнения задачи.
  /// [endDate] - дата и время завершения задачи.
  /// [status] - статус задачи, по умолчанию `TaskStatus.inProcess`.
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.status = TaskStatus.inProcess,
  });

  /// Создаёт задачу из данных, полученных из Firestore.
  /// 
  /// [data] - данные задачи в виде Map.
  /// [documentId] - уникальный идентификатор документа в Firestore.
  /// 
  /// Возвращает объект `Task`.
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

  /// Преобразует объект задачи в Map для отправки в базу данных.
  /// 
  /// Возвращает Map с данными задачи.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
    };
  }

  /// Определяет текущий статус задачи в зависимости от времени.
  /// 
  /// [now] - текущее время.
  /// 
  /// Возвращает `TaskStatus` - актуальный статус задачи.
  TaskStatus determineStatus(DateTime now) {
    if (now.isAfter(endDate)) {
      return TaskStatus.overdued; // Задача просрочена
    } else {
      return status; // Статус задачи, если не просрочена
    }
  }
}
