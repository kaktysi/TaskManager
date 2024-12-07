import 'package:flutter/material.dart';

/// Виджет фильтра, представляющий собой кнопку с иконкой фильтра.
/// 
/// Используется для отображения кнопки фильтрации на экране. При нажатии на кнопку
/// обычно открывается меню фильтрации или выполняется другое действие фильтрации.
class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(153, 159, 249, 1), // Цвет фона кнопки
      ),
      padding: const EdgeInsets.all(16), // Отступы внутри кнопки
      child: const Icon(
        Icons.filter_alt, // Иконка фильтра
        color: Colors.white, // Цвет иконки
      ),
    );
  }
}
