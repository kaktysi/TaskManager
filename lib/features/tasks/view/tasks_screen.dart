import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/tasks/bloc/tasks_bloc.dart';
import 'package:task_manager/features/tasks/tasks.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

/// Экран задач, отображающий список задач с возможностью фильтрации и сортировки.
///
/// Использует [Bloc] для управления состоянием задач и отображает список задач
/// с возможностью сортировки, фильтрации по статусу и пометки задач как завершённых.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task>? taskList;

  final _taskBloc = TasksBloc(
    GetIt.I<AbstractTasksRepository>(),
  );

  /// Инициализация блока и загрузка задач.
  @override
  void initState() {
    _taskBloc.add(LoadTasks()); // Загрузка всех задач
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(context), // Заголовок экрана
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Выпадающий список для сортировки задач
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _taskBloc.add(LoadTasks(
                          filter: value)); // Применение выбранной сортировки
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'name',
                      child: Text('Sort by Name'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'time_left',
                      child: Text('Sort by Time Left'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'creation_date',
                      child: Text('Sort by Creation Date'),
                    ),
                  ],
                  child: const FilterWidget(), // Виджет для сортировки
                ),
                const SizedBox(width: 30),
                // Фильтр по статусу задач
                FilterStatusMenu(
                  onFilterChanged: (selectedStatuses) {
                    _taskBloc.add(LoadTasksByStatus(
                        statuses:
                            selectedStatuses)); // Применение выбранных статусов
                  },
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    final overdueTasks = taskList
                            ?.where(
                                (task) => task.status == TaskStatus.overdued)
                            .length ?? 0;

                    // Отображение количества просроченных задач
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You have $overdueTasks overdue tasks',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color.fromRGBO(
                        153, 159, 249, 1), // фиолетовый цвет
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(129, 1, 170, 245),
            thickness: 2.0,
          ),
          // Список задач с использованием блока состояния
          Expanded(
              child: BlocBuilder<TasksBloc, TasksBlocState>(
            bloc: _taskBloc,
            builder: (context, state) {
              if (state is TasksLoaded) {
                taskList = state.taskList; // Загрузка списка задач
                _overdueCheck();
                return ListView.builder(
                  itemCount: state.taskList.length, // Количество задач в списке
                  itemBuilder: (context, index) {
                    taskList = state.taskList;
                    final task = state.taskList[index];
                    final now = DateTime.now();
                    final currentStatus =
                        task.determineStatus(now); // Определение статуса задачи
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
                                task.title, // Имя задачи
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                      currentStatus), // Цвет статуса
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
                              '${DateFormat('yyyy-MM-dd HH:mm').format(task.startDate.toLocal())} -\n${DateFormat('yyyy-MM-dd HH:mm').format(task.endDate.toLocal())}', // Даты начала и конца
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
                            icon: _getButtonIcon(
                                currentStatus), // Иконка в зависимости от статуса
                            onPressed: currentStatus == TaskStatus.completed
                                ? null // Кнопка отключена, если задача завершена
                                : () =>
                                    _onButtonPressed(task), // Обработка нажатия
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  currentStatus == TaskStatus.overdued
                                      ? Colors.red
                                      : currentStatus == TaskStatus.completed
                                          ? Colors.grey.withOpacity(0.3)
                                          : Colors.blueAccent,
                            ),
                          ),
                          onTap: () => _navigate(context,
                              task.id), // Переход на страницу деталей задачи
                        ),
                      ),
                    );
                  },
                );
              }
              if (state is TasksLoadingFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Something went wrong',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          )),
                      const Text('Please try again later',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          _taskBloc.add(
                              LoadTasks()); // Попробовать загрузить задачи снова
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator()); // Индикатор загрузки
            },
          )),
          CreateButton(context) // Кнопка для создания новой задачи
        ],
      ),
    );
  }

  /// Проверка на просроченные задачи.
  /// Если задача просрочена, ее статус обновляется на "overdued".
  void _overdueCheck()  {
    final now = DateTime.now(); // Текущее время
    if (taskList != null) {
      for (var task in taskList!) {
        if (task.endDate.isBefore(now) && task.status != TaskStatus.overdued) {
          // Если задача просрочена, обновляем статус
          final updatedTask = Task(
            id: task.id,
            title: task.title,
            description: task.description,
            startDate: task.startDate,
            endDate: task.endDate,
            status: TaskStatus.overdued,
          );
          // Сохраняем обновление через репозиторий
          GetIt.I<AbstractTasksRepository>().updateTask(updatedTask);
        }
      }
    }
  }

  /// Возвращает цвет для отображения статуса задачи.
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

  /// Возвращает иконку для кнопки в зависимости от статуса задачи.
  Icon _getButtonIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return const Icon(Icons.check, color: Colors.green);
      case TaskStatus.overdued:
        return const Icon(Icons.restore_from_trash, color: Colors.red);
      default:
        return const Icon(Icons.pause, color: Colors.blueAccent);
    }
  }

  /// Обрабатывает нажатие на кнопку для завершения или возобновления задачи.
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
    initState();
  }

  /// Навигация на экран деталей задачи.
  Future<void> _navigate(context, taskId) async {
    final task = await GetIt.I<AbstractTasksRepository>().getTaskById(taskId);
    
    if (task != null) {
      GoRouter.of(context)
          .go('/task_details', extra: task); // Переход с данными таски
    } else {
      log('Task not found');
    }
  }
}
