import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Для SharedPreferences

/// Экран входа
/// Этот экран позволяет пользователю войти в систему с использованием email и пароля.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Контроллер для поля email
  final _passwordController = TextEditingController(); // Контроллер для поля пароля
  final _formKey = GlobalKey<FormState>(); // Ключ для формы

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Метод для входа в систему
  /// После успешного входа сохраняется состояние авторизации и происходит переход на экран задач.
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) { // Проверка валидности формы
      try {
        // Вход пользователя с помощью email и пароля
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Сохраняем состояние авторизации после успешного входа
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Сохранение флага авторизации

        // Перенаправление на экран задач после успешного входа
        if (mounted) {
          context.go("/tasks");
        }
      } on FirebaseAuthException catch (e) {
        // В случае ошибки входа выводим сообщение об ошибке
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
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
              borderRadius: BorderRadius.circular(16.0), // Закругление углов
            ),
            child: Form(
              key: _formKey, // Привязка ключа к форме
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign In',
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
                    onPressed: _signIn, // Вход с помощью метода _signIn
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(239, 147, 162, 1), // Красный цвет кнопки
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white, // Белый текст на кнопке
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => context.go('/register'), // Перенаправление на экран регистрации
                    child: const Text(
                      'Not registered yet? Sign Up',
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
