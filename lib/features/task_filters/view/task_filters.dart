import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskFiltersScreen extends StatefulWidget{
  const TaskFiltersScreen({super.key});

  @override
  State<TaskFiltersScreen> createState() => _TaskFiltersScreenState();
}

class _TaskFiltersScreenState extends State<TaskFiltersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go("/tasks"), 
          icon: const Icon(Icons.arrow_back_ios)
        ),
        title: const Text("Filters"),
      ),
    );
  }

}