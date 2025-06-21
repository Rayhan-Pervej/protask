part of 'check_leave_status_cubit.dart';

sealed class CheckLeaveStatusState {}

final class CheckLeaveStatusLoading extends CheckLeaveStatusState {}

final class CheckLeaveStatusLoaded extends CheckLeaveStatusState {
  final List<dynamic> filteredApplications;

  CheckLeaveStatusLoaded(this.filteredApplications);
}

final class CheckLeaveStatusError extends CheckLeaveStatusState {
  final String message;

  CheckLeaveStatusError(this.message);
}
