part of 'tasks_bloc.dart';

/// Абстрактный базовый класс для состояний в [TasksBloc].
/// Все состояния для [TasksBloc] должны наследоваться от этого класса.
abstract class TasksBlocState {}

/// Начальное состояние [TasksBloc], когда блок еще не был инициализирован.
class TasksBlocInitial extends TasksBlocState {}

/// Состояние, указывающее, что задачи сейчас загружаются.
class TasksLoading extends TasksBlocState {}

/// Состояние, которое указывает на успешную загрузку задач.
/// Содержит список задач, которые были получены.
class TasksLoaded extends TasksBlocState {
  
  /// Конструктор принимает список задач, которые были загружены.
  TasksLoaded({
    required this.taskList, // Список задач, которые были загружены
  });

  /// Список задач, полученный из репозитория.
  final List<Task> taskList;
}

/// Состояние, которое указывает на ошибку при загрузке задач.
/// Содержит исключение, которое было выброшено во время загрузки.
class TasksLoadingFailure extends TasksBlocState {

  /// Конструктор принимает исключение, которое вызвало ошибку.
  TasksLoadingFailure({
    required this.exception, // Исключение, которое вызвало ошибку
  });

  /// Исключение, которое произошло при загрузке задач.
  final Object? exception;
}
