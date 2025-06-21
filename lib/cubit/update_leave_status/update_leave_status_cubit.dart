import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_leave_status_state.dart';

class UpdateLeaveStatusCubit extends Cubit<UpdateLeaveStatusState> {
  UpdateLeaveStatusCubit() : super(UpdateLeaveStatusIntial());

  String? approveStatus;

  Future<void> updateStatus(approveStatus) async {
    emit(UpdateLeaveStatusLoading());
    print(approveStatus);
  }
}
