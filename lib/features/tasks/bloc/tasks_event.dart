part of 'tasks_bloc.dart';

abstract class TasksBlocEvent {}

class LoadTasks extends TasksBlocEvent {
  final String? filter;
  LoadTasks({this.filter});
}

class LoadTasksByStatus extends TasksBlocEvent {
  final List<TaskStatus> statuses;

  LoadTasksByStatus({required this.statuses});
}