import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/tasks/bloc/tasks_bloc.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

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

  @override
  void initState() {
    _taskBloc.add(LoadTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0,
        title: const Text(
          "Tasks",
          style: TextStyle(
            color: Color.fromRGBO(129, 170, 245, 1), // blue
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'log_out') {
                // Логика для выхода из системы
                await FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool(
                    'isLoggedIn', false); // Убираем флаг авторизации
                context.go('/login'); // Перенаправление на экран входа
              } else if (value == 'theme') {}
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(Icons.circle_outlined, size: 18, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Theme'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'log_out',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, size: 18, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Log Out'),
                  ],
                ),
              ),
            ],
            icon: const Icon(
              Icons.settings,
              size: 31,
              color: Color.fromRGBO(239, 147, 162, 1), // Красный
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: const Color.fromARGB(129, 1, 170, 245),
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => context.go("/task_filters"),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor:
                        const Color.fromRGBO(153, 159, 249, 1), // purp
                  ),
                  child: const Icon(
                    Icons.filter_alt,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 0,
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor:
                      const Color.fromRGBO(153, 159, 249, 1), // purp
                  ),
                  child: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 0,
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor:
                        const Color.fromRGBO(153, 159, 249, 1), // purp
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
          Expanded(
              child: BlocBuilder<TasksBloc, TasksBlocState>(
            bloc: _taskBloc,
            builder: (context, state) {
              if (state is TasksLoaded) {
                return ListView.builder(
                  itemCount: state.taskList.length,
                  itemBuilder: (context, index) {
                    final task = state.taskList[index];
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
                              backgroundColor:
                                  currentStatus == TaskStatus.overdued
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
                          _taskBloc.add(LoadTasks());
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                context.go("/task_add");
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color.fromRGBO(153, 159, 249, 1),
              ),
              child: const Text(
                'Create Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
    initState();
  }

  Future<void> _navigate(BuildContext context, String taskId) async {
    final task = await GetIt.I<AbstractTasksRepository>().getTaskById(taskId);
    if (task != null) {
      GoRouter.of(context)
          .go('/task_details', extra: task); // Переход с данными таски
    } else {
      log('Task not found');
    }
  }
}