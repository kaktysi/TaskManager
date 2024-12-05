import 'package:flutter/material.dart';

import '../noticifications/noticifications.dart';
import '../tasks/tasks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          TasksScreen(),
          NoticificationsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            label: 'Tasks',
            icon: Icon(
              Icons.task,
              color: Color.fromRGBO(153, 159, 249, 1), // purp
            ),
          ),
          BottomNavigationBarItem(
            label: 'Noticifications',
            icon: Icon(
              Icons.notification_add,
              color: Color.fromRGBO(153, 159, 249, 1), // purp
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
