import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/tasks/tasks.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProcess:
        return Colors.yellow.withOpacity(0.5);
      case TaskStatus.completed:
        return Colors.green.withOpacity(0.5);
      case TaskStatus.overdued:
        return Colors.red.withOpacity(0.5);
    }
  }

  Icon _getButtonIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return const Icon(Icons.check, color: Colors.green);
      case TaskStatus.overdued:
        return const Icon(Icons.warning, color: Colors.red);
      case TaskStatus.inProcess:
      default:
        return const Icon(Icons.check, color: Colors.white);
    }
  }

  Future<void> _onButtonPressed(Task task) async {
    if (task.status == TaskStatus.inProcess) {
      task = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        startDate: task.startDate,
        endDate: task.endDate,
        status: TaskStatus.completed,
      );
      GetIt.I<AbstractTasksRepository>().updateTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentStatus = task.determineStatus(now);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.title, // Имя таски
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentStatus), // Цвет статуса
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentStatus.name, // Отображаем статус
                  style: const TextStyle(
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
              '${task.startDate.toLocal()} - ${task.endDate.toLocal()}', // Срок выполнения
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          leading: const Icon(
            Icons.task,
            color: Color.fromRGBO(239, 147, 162, 1), // красный
          ),
          trailing: IconButton(
            icon: _getButtonIcon(currentStatus),
            onPressed: currentStatus == TaskStatus.completed
                ? null // Кнопка отключена, если задача завершена
                : () => _onButtonPressed(task),
            style: IconButton.styleFrom(
              backgroundColor: currentStatus == TaskStatus.overdued
                ? Colors.red
                : currentStatus == TaskStatus.completed
                ? Colors.grey.withOpacity(0.3)
                : Colors.blueAccent,
            ),
          ),
          onTap: () => _navigate(context, task.id),
        ),
      ),
    );
  }

  Future<void> _navigate(BuildContext context, String taskId) async {
    final task = await GetIt.I<AbstractTasksRepository>().getTaskById(taskId);
    if (task != null) {
      GoRouter.of(context).go('/task_details', extra: task); // Переход с данными таски
    } else {
      log('Task not found');
    }
  }
}
