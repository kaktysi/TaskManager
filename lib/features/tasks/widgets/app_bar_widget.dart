import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Виджет для создания кастомной панели приложений (AppBar) с функцией выхода из системы.
/// Используется для отображения заголовка и кнопки для выхода из аккаунта.
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;

  /// Конструктор виджета.
  /// 
  /// Принимает [context], который используется для навигации при выходе.
  const AppBarWidget(this.context, {super.key});

  /// Возвращает предпочтительный размер для AppBar.
  /// Используется для определения высоты AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Строит виджет AppBar.
  /// 
  /// Включает:
  /// - Заголовок с текстом "Tasks".
  /// - Кнопку для выхода из аккаунта, которая вызывает метод [onSelected].
  ///   При выборе "Log Out" происходит выход из аккаунта с использованием [FirebaseAuth],
  ///   а также очистка информации о состоянии входа в [SharedPreferences]. После этого выполняется переход на экран входа.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text(
        "Tasks",
        style: TextStyle(
          color: Color.fromRGBO(129, 170, 245, 1),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        // Кнопка настройки с выпадающим меню
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'log_out') {
              // Выход из аккаунта
              await FirebaseAuth.instance.signOut();
              
              // Обновление состояния пользователя в SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              
              // Переход на экран входа
              if(context.mounted) {
                context.go('/login');
              }
            }
          },
          itemBuilder: (BuildContext context) => [
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
            color: Color.fromRGBO(239, 147, 162, 1),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(3.0),
        child: Divider(
          color: Color.fromARGB(129, 1, 170, 245),
          thickness: 2.0,
        ),
      ),
    );
  }
}
