part of 'tasks_bloc.dart';

abstract class TasksBlocState {}

class TasksBlocInitial extends TasksBlocState {}

class TasksLoading extends TasksBlocState {}

class TasksLoaded extends TasksBlocState {
  TasksLoaded({
    required this.taskList,
  });

  final List<Task> taskList;
}

class TasksLoadingFailure extends TasksBlocState {
  TasksLoadingFailure({
    required this.exception
  });

  final Object? exception;
}