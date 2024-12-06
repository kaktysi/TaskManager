import 'package:task_manager/repositories/tasks/tasks.dart';

abstract class AbstractTasksRepository {
  Future<List<Task>> getTasks(String? filter); // Получить все задачи
  Future<List<Task>> getTasksByStatuses(List<TaskStatus> statuses); // Новый метод
  Future<Task?> getTaskById(String id); // Получить задачу по ID
  Future<void> addTask(Task task); // Добавить задачу
  Future<void> updateTask(Task task); // Обновить задачу
  Future<void> deleteTask(String id); // Удалить задачу
}