import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

/// Экран уведомлений
/// Этот экран отображает уведомления о задачах, которые заканчиваются в течение следующего часа.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Task>? notificationTasks; // Список уведомлений (задач)
  Timer? _timer; // Таймер для обновления уведомлений

  @override
  void initState() {
    super.initState();
    _loadNotificationTasks(); // Загрузка уведомлений

    // Обновляем уведомления каждые 60 секунд
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _loadNotificationTasks();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Остановка таймера при уничтожении виджета
    super.dispose();
  }

  /// Метод для загрузки уведомлений
  /// Фильтрует задачи, которые заканчиваются через 60 минут или меньше.
  void _loadNotificationTasks() async {
    final tasks = await GetIt.I<AbstractTasksRepository>()
        .getTasks(null); // Получаем задачи
    final now = DateTime.now();

    // Фильтруем задачи, у которых осталось менее часа до завершения
    final filteredTasks = tasks.where((task) {
      final timeLeft = task.endDate.difference(now);
      return timeLeft.inMinutes > 0 && timeLeft.inMinutes <= 60;
    }).toList();

    setState(() {
      notificationTasks = filteredTasks; // Обновляем список уведомлений
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor:
            const Color.fromRGBO(153, 159, 249, 1), // Фоновый цвет для AppBar
      ),
      body: notificationTasks == null
          ? const Center(child: CircularProgressIndicator()) // Загрузка данных
          : notificationTasks!.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications at the moment',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ) // Нет уведомлений
              : ListView.builder(
                  itemCount:
                      notificationTasks!.length, // Количество уведомлений
                  itemBuilder: (context, index) {
                    final task = notificationTasks![index];
                    final timeLeft =
                        task.endDate.difference(DateTime.now()).inMinutes;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.blueAccent.withOpacity(0.2), // Фон задачи
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.title, // Название задачи
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.red, // Красный для предупреждения
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Warning', // Статус уведомления
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Less than $timeLeft minutes left\nEnds at: ${DateFormat('yyyy-MM-dd HH:mm').format(task.endDate.toLocal())}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.warning, // Иконка предупреждения
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
