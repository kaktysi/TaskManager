import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Виджет для создания кнопки "Create Task" с переходом на экран добавления задачи.
/// При нажатии кнопка перенаправляет пользователя на экран добавления задачи.
class CreateButton extends StatelessWidget {
  final BuildContext context;

  /// Конструктор виджета.
  /// 
  /// Принимает [context], который используется для навигации на экран добавления задачи.
  const CreateButton(this.context, {super.key});

  /// Строит кнопку с текстом "Create Task", которая при нажатии выполняет переход на экран добавления задачи.
  /// 
  /// Кнопка имеет:
  /// - Отступы по краям с помощью `EdgeInsets.all(16.0)`.
  /// - Стиль кнопки с минимальным размером и заданным фоном (цвет `Color.fromRGBO(153, 159, 249, 1)`).
  /// - Текст кнопки с размером шрифта 18 и жирным начертанием.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => context.go("/task_add"),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: const Color.fromRGBO(153, 159, 249, 1),
        ),
        child: const Text(
          'Create Task',
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
