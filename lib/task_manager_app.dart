import 'package:flutter/material.dart';
import 'package:task_manager/views/views.dart';

class TaskManagerApp extends StatelessWidget{
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}