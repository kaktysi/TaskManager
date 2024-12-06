import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager/firebase_options.dart';

import 'repositories/notifications/notification_service.dart';
import 'repositories/tasks/tasks.dart';
import 'task_manager_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.I.registerLazySingleton<AbstractTasksRepository>(
    () => FirebaseTaskRepository());

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const TaskManagerApp());
}