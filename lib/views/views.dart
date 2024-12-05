import 'package:go_router/go_router.dart';
import 'package:task_manager/features/task_details/task_details.dart';

import '../features/home/home.dart';
import '../features/login/login_screen.dart';
import '../features/noticifications/noticifications.dart';
import '../features/registration/register_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/task_add/task_add.dart';
import '../features/task_filters/task_filters.dart';
import '../features/tasks/tasks.dart';
import '../repositories/tasks/tasks.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/task_add',
      builder: (context, state) {
        return const TaskAddScreen();
      },
    ),
    GoRoute(
      path: '/task_filters',
      builder: (context, state) {
        return const TaskFiltersScreen();
      },
    ),
    GoRoute(
      path: '/task_details',
      builder: (context, state) {
        final task = state.extra as Task;
        return TaskDetailsScreen(task: task);
      },
    ),
    ShellRoute(
      builder: (context, state, child) => const HomeScreen(),
      routes: [
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: '/noticifications',
          builder: (context, state) {
            return const NoticificationsScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const TaskAddScreen(),
    ),
  ],
);
