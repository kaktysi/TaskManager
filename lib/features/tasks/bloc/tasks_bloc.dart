import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager/repositories/tasks/tasks.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksBlocEvent, TasksBlocState> {
  TasksBloc(this.tasksRepository) : super(TasksBlocInitial()) {
    on<LoadTasks>((event, emit) async {
      try {
        emit(TasksLoading());
        final taskList = await GetIt.I<AbstractTasksRepository>().getTasks();
        emit(TasksLoaded(taskList: taskList));
      } on Exception catch (e) {
        emit(TasksLoadingFailure(exception: e));
      }
   });
  }
  final AbstractTasksRepository tasksRepository;
}