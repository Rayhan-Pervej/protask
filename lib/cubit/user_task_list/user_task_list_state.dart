part of 'user_task_list_cubit.dart';
abstract class UserTaskListState {}

class UserTaskListInitial extends UserTaskListState {}

class UserTaskListLoading extends UserTaskListState {}

class UserTaskListLoaded extends UserTaskListState {
  final List<dynamic> userTasks;

  UserTaskListLoaded(this.userTasks);
}

class UserTaskListError extends UserTaskListState {
  final String message;

  UserTaskListError(this.message);
}
