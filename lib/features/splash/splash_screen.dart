import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Экран приветствия (Splash Screen)
/// Этот экран отображается при запуске приложения. Он проверяет статус авторизации пользователя и перенаправляет его на соответствующий экран (экран задач или экран входа).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Проверка статуса авторизации при запуске экрана
  }

  /// Метод для проверки статуса авторизации пользователя
  /// Использует `SharedPreferences` для получения информации о том, авторизован ли пользователь.
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance(); // Получение экземпляра SharedPreferences
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Чтение значения 'isLoggedIn' (по умолчанию false)

    // Задержка перед перенаправлением, чтобы показать экран приветствия на несколько секунд
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (isLoggedIn) {
        if (mounted) {
          context.go("/tasks"); // Если пользователь авторизован, переходим на экран задач
        }
      } else {
        if (mounted) {
          context.go("/login"); // Если пользователь не авторизован, переходим на экран входа
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/gif/splash.gif', // Путь к анимированному GIF для экрана приветствия
      gifWidth: 1080, // Ширина GIF
      gifHeight: 2220, // Высота GIF
    );
  }
}
