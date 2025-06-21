part of 'apply_leave_cubit.dart';

abstract class ApplyLeaveState {}

class ApplyLeaveInitial extends ApplyLeaveState {}

class ApplyLeaveLoading extends ApplyLeaveState {}

class ApplyLeaveLoaded extends ApplyLeaveState {}

class ApplyLeaveError extends ApplyLeaveState {
  final String message;
  ApplyLeaveError(this.message);
}
