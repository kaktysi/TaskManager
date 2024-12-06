import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Для форматирования даты

import '../../../repositories/tasks/tasks.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  DateTime? _startDate;
  DateTime? _endDate;

  final _repository = GetIt.I<AbstractTasksRepository>();

  /// Выбор даты с помощью календаря
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


  /// Сохранение задачи
  void _saveTask() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      if (_startDate != null && _endDate != null) {
        final newTask = Task(
          id: '', 
          title: _title!,
          description: _description!,
          startDate: _startDate!,
          endDate: _endDate!,
        );

        // Добавить задачу в Firestore
        _repository.addTask(newTask);
        context.go("/tasks");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, выберите даты.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(129, 170, 245, 1),
        leading: IconButton(
            onPressed: () => context.go("/tasks"),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Date: ${_startDate != null ? DateFormat.yMd().format(_startDate!) : 'Not selected'}',
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(153, 159, 249, 1),
                    ),
                    onPressed: () {
                      _selectTime(context, true);
                      _selectDate(context, false);
                    },
                    child: const Text('Select'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End Date: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : 'Not selected'}',
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(153, 159, 249, 1),
                    ),
                    onPressed: () {
                      _selectTime(context, true);
                      _selectDate(context, false);
                    },
                    child: const Text('Select'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromRGBO(239, 147, 162, 1),
                ),
                child: const Text(
                  'Save Task',
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