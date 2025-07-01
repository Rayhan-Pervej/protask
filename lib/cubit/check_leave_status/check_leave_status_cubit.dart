import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';
import 'package:protask/services/client_config.dart/token_handle.dart';

part 'check_leave_status_state.dart';

class CheckLeaveStatusCubit extends Cubit<CheckLeaveStatusState> {
  CheckLeaveStatusCubit() : super(CheckLeaveStatusLoading());
  ApiHandle apiHandle = ApiHandle();
  Future<void> fetchLeaveApplication() async {
    try {
      var token = await SharedPrefs().getToken();
      if (token == null) {
        emit(CheckLeaveStatusError('Token not found'));
        return;
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      int userId = decodedToken['id'];
      final applications = await apiHandle.getUserLeaveApplications(userId);
      final List<Map<String, dynamic>> filteredApplications =
          applications.map((applications) {
            final updatedDateStr = applications['updated_at'] as String?;
            final approvedDate =
                updatedDateStr != null
                    ? DateTime.tryParse(updatedDateStr) ?? DateTime(0)
                    : DateTime(0);
            return {
              'id': applications['id'],
              'subject': applications['subject'],
              'to': applications['to'],
              'from':applications['from'],
              'reason': applications['reason'],
              'startDate': applications['start_date'],
              'endDate': applications['end_date'],
              'status': applications['status'], // updated status
              'created': applications['created_at'],
              'updated': approvedDate,
            };
          }).toList();
      emit(CheckLeaveStatusLoaded(filteredApplications));
    } catch (e) {
      emit(CheckLeaveStatusError(e.toString()));
    }
  }
}
