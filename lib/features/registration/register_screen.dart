import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Для переходов между экранами

/// Экран регистрации
/// Этот экран позволяет пользователю зарегистрировать аккаунт с помощью email и пароля.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController(); // Контроллер для поля email
  final _passwordController = TextEditingController(); // Контроллер для поля пароля
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _auth = FirebaseAuth.instance; // Экземпляр FirebaseAuth для работы с аутентификацией

  /// Метод для регистрации пользователя
  /// При успешной регистрации показывается сообщение, иначе выводится ошибка.
  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) { // Проверка валидности формы
      try {
        // Регистрация пользователя с помощью email и пароля
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Если регистрация прошла успешно, показываем сообщение
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Регистрация прошла успешно')),
          );
        }
      } on FirebaseAuthException catch (e) {
        // В случае ошибки регистрации показываем сообщение об ошибке
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${e.message}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(129, 170, 245, 1), // Фиолетовый фон
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white, // Белый фон для формы
              borderRadius: BorderRadius.circular(16.0), // Закругление углов формы
            ),
            child: Form(
              key: _formKey, // Привязка ключа к форме
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(129, 170, 245, 1), // Голубой цвет заголовка
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController, // Контроллер для поля email
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      // Валидатор для поля email
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController, // Контроллер для поля пароля
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true, // Скрытие ввода пароля
                    validator: (value) {
                      // Валидатор для поля пароля
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register, // Вызов метода регистрации
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(239, 147, 162, 1), // Красный цвет кнопки
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white, // Белый текст на кнопке
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => context.go('/login'), // Перенаправление на экран входа
                    child: const Text(
                      'Already have an account? Sign In',
                      style: TextStyle(
                        color: Color.fromRGBO(129, 170, 245, 1), // Голубой цвет текста
                        decoration: TextDecoration.underline, // Подчеркивание текста
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
