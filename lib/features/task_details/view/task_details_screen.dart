import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/tasks/tasks.dart';

/// Экран для отображения и редактирования деталей задачи.
class TaskDetailsScreen extends StatefulWidget {
  /// Задача, детали которой нужно отобразить.
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TaskStatus _status;

  /// Репозиторий для работы с задачами.
  final _repository = GetIt.I<AbstractTasksRepository>();

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров и значений для отображаемой задачи.
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _startDate = widget.task.startDate;
    _endDate = widget.task.endDate;
    _status = widget.task.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Открывает диалог выбора даты и времени.
  Future<void> _pickDateTime({required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _startDate : _endDate),
      );

      if (pickedTime != null) {
        setState(() {
          final dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isStart) {
            _startDate = dateTime;
          } else {
            _endDate = dateTime;
          }
        });
      }
    }
  }

  /// Обновляет задачу в репозитории.
  Future<void> _updateTask() async {
    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("End date must be after start date"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: _startDate,
      endDate: _endDate,
      status: _status,
    );

    await _repository.updateTask(updatedTask);
    if (mounted) {
      context.go("/tasks");
    }
  }

  /// Удаляет задачу из репозитория.
  Future<void> _deleteTask() async {
    await _repository.deleteTask(widget.task.id);
    if (mounted) {
      context.go("/tasks");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
        leading: IconButton(
          onPressed: () => context.go("/tasks"),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле для ввода заголовка задачи.
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 16),
            // Поле для ввода описания задачи.
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Строка с выбором времени начала и конца задачи.
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Start Date & Time"),
                      TextButton(
                        onPressed: () => _pickDateTime(isStart: true),
                        child: Text(
                          "${_startDate.toLocal().toIso8601String().split('T')[0]} ${_startDate.toLocal().hour}:${_startDate.toLocal().minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("End Date & Time"),
                      TextButton(
                        onPressed: () => _pickDateTime(isStart: false),
                        child: Text(
                          "${_endDate.toLocal().toIso8601String().split('T')[0]} ${_endDate.toLocal().hour}:${_endDate.toLocal().minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Выпадающий список для выбора статуса задачи.
            DropdownButtonFormField<TaskStatus>(
              value: _status,
              decoration: const InputDecoration(labelText: "Status"),
              items: TaskStatus.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
            ),
            const Spacer(),
            // Кнопка для сохранения изменений.
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
