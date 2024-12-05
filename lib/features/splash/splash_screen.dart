import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (isLoggedIn) {
        if (mounted) {
          context.go("/tasks"); // Перенаправление на экран задач, если пользователь авторизован
        }
      } else {
        if (mounted) {
          context.go("/login"); // Перенаправление на экран входа
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: 'assets/gif/splash.gif',
      gifWidth: 1080,
      gifHeight: 2220,
    );
  }
}
