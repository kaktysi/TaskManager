import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

// Блок для управления состоянием задач в приложении.
/// [TasksBloc] отвечает за управление состоянием задач, получаемых через репозиторий.
/// Блок реагирует на два типа событий:
/// - [LoadTasks] — для загрузки всех задач с возможностью применения фильтра.
/// - [LoadTasksByStatus] — для загрузки задач по статусу.
class TasksBloc extends Bloc<TasksBlocEvent, TasksBlocState> {
  
  /// Конструктор для инициализации [TasksBloc].
  /// Принимает [tasksRepository], который будет использоваться для получения данных о задачах.
  ///
  /// [tasksRepository] — репозиторий, который реализует методы для получения задач.
  TasksBloc(this.tasksRepository) : super(TasksBlocInitial()) {

    // Обработчик события [LoadTasks], которое загружает список задач.
    /// Это событие инициирует загрузку задач. В нем можно передавать фильтры для сортировки задач.
    ///
    /// При обработке этого события:
    /// - Устанавливается состояние [TasksLoading], что означает начало загрузки данных.
    /// - Далее данные загружаются через репозиторий с помощью метода [getTasks].
    /// - После успешной загрузки данных, блок обновляется в состояние [TasksLoaded], где содержится список задач.
    /// - В случае ошибки, блок переходит в состояние [TasksLoadingFailure], и в него передается информация о возникшей ошибке.
    on<LoadTasks>((event, emit) async {
      try {
        emit(TasksLoading()); // Начинаем загрузку задач
        final taskList = await tasksRepository.getTasks(event.filter); // Загружаем задачи с фильтром (если он есть)
        emit(TasksLoaded(taskList: taskList)); // Успешная загрузка, обновляем состояние с задачами
      } on Exception catch (e) {
        emit(TasksLoadingFailure(exception: e)); // Ошибка загрузки задач, обновляем состояние с ошибкой
      }
    });

    // Обработчик события [LoadTasksByStatus], которое загружает задачи по статусу.
    /// Это событие инициирует загрузку задач с определенными статусами.
    ///
    /// При обработке этого события:
    /// - Устанавливается состояние [TasksLoading], что означает начало загрузки.
    /// - Загружаются задачи с помощью метода [getTasksByStatuses], передавая список статусов.
    /// - После успешной загрузки данных, блок обновляется в состояние [TasksLoaded], где содержится список задач.
    /// - В случае ошибки, блок переходит в состояние [TasksLoadingFailure], и в него передается информация о возникшей ошибке.
    on<LoadTasksByStatus>((event, emit) async {
      emit(TasksLoading()); // Начинаем загрузку задач по статусу
      try {
        final tasks = await tasksRepository.getTasksByStatuses(event.statuses); // Загружаем задачи с выбранными статусами
        emit(TasksLoaded(taskList: tasks)); // Успешная загрузка, обновляем состояние с задачами
      } catch (e) {
        emit(TasksLoadingFailure(exception: e)); // Ошибка загрузки задач, обновляем состояние с ошибкой
      }
    });
  }

  // Репозиторий для работы с задачами.
  /// [tasksRepository] используется для загрузки задач и их обновления.
  final AbstractTasksRepository tasksRepository;
}
