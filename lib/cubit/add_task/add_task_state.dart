part of 'add_task_cubit.dart';

abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskLoaded extends AddTaskState {
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> boards;
  final int? selectedProjectId;
  final int? selectedBoardId;
  final bool isSubmitting;

  AddTaskLoaded(
    this.projects,
    this.boards,
    this.selectedProjectId,
    this.selectedBoardId, {
    this.isSubmitting = false, // Default is false
  });
}

class AddTaskError extends AddTaskState {
  final String message;
  AddTaskError(this.message);
}
