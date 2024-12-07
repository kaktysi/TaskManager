import 'package:task_manager/repositories/tasks/tasks.dart';

/// Абстрактный класс репозитория задач, который предоставляет методы для работы с задачами.
/// Этот класс предназначен для реализации различных источников данных (Firestore
abstract class AbstractTasksRepository {
  /// Получить все задачи с возможностью фильтрации.
  /// 
  /// [filter] - необязательный параметр фильтрации задач.
  /// Если фильтр не предоставлен, возвращаются все задачи.
  /// 
  /// Возвращает список задач.
  Future<List<Task>> getTasks(String? filter);

  /// Получить задачи по статусам.
  /// 
  /// [statuses] - список статусов, по которым нужно получить задачи.
  /// 
  /// Возвращает список задач с указанными статусами.
  Future<List<Task>> getTasksByStatuses(List<TaskStatus> statuses);

  /// Получить задачу по ID.
  /// 
  /// [id] - уникальный идентификатор задачи.
  /// 
  /// Возвращает задачу с указанным ID, если она существует, иначе возвращает null.
  Future<Task?> getTaskById(String id);

  /// Добавить новую задачу.
  /// 
  /// [task] - задача, которую нужно добавить.
  /// 
  /// Возвращает `Future`, завершение которого подтверждает добавление задачи.
  Future<void> addTask(Task task);

  /// Обновить существующую задачу.
  /// 
  /// [task] - задача с обновлёнными данными.
  /// 
  /// Возвращает `Future`, завершение которого подтверждает обновление задачи.
  Future<void> updateTask(Task task);

  /// Удалить задачу по ID.
  /// 
  /// [id] - уникальный идентификатор задачи, которую нужно удалить.
  /// 
  /// Возвращает `Future`, завершение которого подтверждает удаление задачи.
  Future<void> deleteTask(String id);
}
