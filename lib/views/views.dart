import 'package:go_router/go_router.dart';
import 'package:task_manager/features/home/home_screen.dart';
import 'package:task_manager/features/task_details/task_details.dart';
import '../features/login/login_screen.dart';
import '../features/notifications/noticifications.dart';
import '../features/registration/register_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/task_add/task_add.dart';
import '../features/tasks/tasks.dart';
import '../repositories/tasks/tasks.dart';

/// Основной маршрутизатор приложения с использованием GoRouter.
/// Он управляет переходами между экранами и маршрутизирует пользовательский интерфейс.
final GoRouter router = GoRouter(
  // Начальный маршрут (экран, с которого начинается приложение)
  initialLocation: '/',
  
  // Множество маршрутов, которые определяют пути и связанные с ними экраны
  routes: <RouteBase>[
    // Маршрут для экрана Splash (экран загрузки)
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();  // Отображается экран загрузки
      },
    ),
    
    // Маршрут для экрана входа в систему (Login)
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();  // Отображается экран для входа
      },
    ),
    
    // Маршрут для экрана регистрации
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterScreen();  // Отображается экран регистрации
      },
    ),
    
    // Маршрут для экрана добавления задачи
    GoRoute(
      path: '/task_add',
      builder: (context, state) {
        return const TaskAddScreen();  // Отображается экран для добавления новой задачи
      },
    ),
    
    // Маршрут для экрана деталей задачи
    GoRoute(
      path: '/task_details',
      builder: (context, state) {
        // Получение задачи, переданной через state.extra
        final task = state.extra as Task;
        return TaskDetailsScreen(task: task);  // Отображение экрана с деталями задачи
      },
    ),
    
    // ShellRoute используется для организации вложенных маршрутов
    ShellRoute(
      builder: (context, state, child) => const HomeScreen(),  // Главная оболочка, которая всегда будет показываться
      routes: [
        // Маршрут для экрана задач (TaskScreen)
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TasksScreen(),  // Отображается экран со списком задач
        ),
        
        // Маршрут для экрана уведомлений
        GoRoute(
          path: '/notifications',
          builder: (context, state) {
            return const NotificationScreen();  // Отображается экран с уведомлениями
          },
        ),
      ],
    ),
  ],
);
