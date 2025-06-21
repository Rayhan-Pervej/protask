part of 'update_leave_status_cubit.dart';

abstract class UpdateLeaveStatusState {}

class UpdateLeaveStatusIntial extends UpdateLeaveStatusState {}

class UpdateLeaveStatusLoading extends UpdateLeaveStatusState {}

class UpdateLeaveStatusLoaded extends UpdateLeaveStatusState {}

class UpdateLeaveStatusError extends UpdateLeaveStatusState {
  final String message;
  UpdateLeaveStatusError(this.message);
}
