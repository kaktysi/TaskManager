import 'models/models.dart';

abstract class AbstractTasksRepository {
  Future<List<Task>> getTasks(); // Получить все задачи
  Future<Task?> getTaskById(String id); // Получить задачу по ID
  Future<void> addTask(Task task); // Добавить задачу
  Future<void> updateTask(Task task); // Обновить задачу
  Future<void> deleteTask(String id); // Удалить задачу
}