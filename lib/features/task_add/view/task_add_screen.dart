import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Для форматирования даты

import '../../../repositories/tasks/tasks.dart';

/// Экран добавления новой задачи
/// Этот экран позволяет пользователю создать новую задачу с выбором даты начала и окончания, а также добавлением заголовка и описания задачи.
class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  // Ключ формы для валидации
  final _formKey = GlobalKey<FormState>();

  // Переменные для хранения данных задачи
  String? _title;
  String? _description;
  DateTime? _startDate;
  DateTime? _endDate;

  // Репозиторий для работы с задачами
  final _repository = GetIt.I<AbstractTasksRepository>();

  /// Метод для выбора даты с помощью календаря
  /// [context] - контекст экрана, [isStartDate] - флаг, указывающий, является ли выбранная дата датой начала задачи.
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  /// Метод для выбора времени с помощью пикера времени
  /// [context] - контекст экрана, [isStartTime] - флаг, указывающий, является ли выбранное время временем начала задачи.
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _startDate = DateTime(
            _startDate?.year ?? DateTime.now().year,
            _startDate?.month ?? DateTime.now().month,
            _startDate?.day ?? DateTime.now().day,
            selectedTime.hour,
            selectedTime.minute,
          );
        } else {
          _endDate = DateTime(
            _endDate?.year ?? DateTime.now().year,
            _endDate?.month ?? DateTime.now().month,
            _endDate?.day ?? DateTime.now().day,
            selectedTime.hour,
            selectedTime.minute,
          );
        }
      });
    }
  }

  /// Метод для сохранения задачи
  /// Сначала валидирует форму, затем сохраняет данные задачи в репозитории, если выбраны даты начала и окончания.
  void _saveTask() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      if (_startDate != null && _endDate != null) {
        final newTask = Task(
          id: '', // Новый объект задачи без ID
          title: _title!,
          description: _description!,
          startDate: _startDate!,
          endDate: _endDate!,
        );

        // Добавление задачи в репозиторий
        _repository.addTask(newTask);
        context.go("/tasks"); // Перенаправление на экран со списком задач
      } else {
        // Показываем уведомление, если не выбраны даты
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please, choose dates')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task', // Заголовок экрана
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(129, 170, 245, 1), // Цвет фона AppBar
        leading: IconButton(
            onPressed: () => context.go("/tasks"), // Кнопка для возврата на экран со списком задач
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Указываем ключ формы
          child: Column(
            children: [
              // Поле для ввода заголовка задачи
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title'; // Валидация для обязательного поля
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 10),
              // Поле для ввода описания задачи
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3, // Описание может занимать до 3 строк
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 20),
              // Ряд для выбора даты начала
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Date: ${_startDate != null ? DateFormat.yMd().format(_startDate!) : 'Not selected'}', // Отображаем выбранную дату начала
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(153, 159, 249, 1),
                    ),
                    onPressed: () {
                      _selectTime(context, true); // Выбор времени начала
                      _selectDate(context, true); // Выбор даты начала
                    },
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Ряд для выбора даты окончания
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End Date: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : 'Not selected'}', // Отображаем выбранную дату окончания
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(153, 159, 249, 1),
                    ),
                    onPressed: () {
                      _selectTime(context, false); // Выбор времени окончания
                      _selectDate(context, false); // Выбор даты окончания
                    },
                    child:  const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ),
                ],
              ),
              const Spacer(),
              // Кнопка для сохранения задачи
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Устанавливаем размер кнопки
                  backgroundColor: const Color.fromRGBO(239, 147, 162, 1),
                ),
                child: const Text(
                  'Save Task', // Текст кнопки
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
