part of 'my_task_list_cubit.dart';

abstract class MyTaskListState {}

class MyTaskListLoading extends MyTaskListState {}

class MyTaskListLoaded extends MyTaskListState {
  final List<dynamic> tasks;

  MyTaskListLoaded(this.tasks);
}

class MyTaskListError extends MyTaskListState {
  final String message;

  MyTaskListError(this.message);
}

class TaskStatusUpdating extends MyTaskListState {}

class UpdateTaskStatusSuccess extends MyTaskListState {
  final String message;
  final String newStatus;
  final String? newListId;

  UpdateTaskStatusSuccess({
    required this.message,
    required this.newStatus,
    this.newListId,
  });
}
