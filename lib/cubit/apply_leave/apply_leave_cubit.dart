import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/snackbar/snackbar.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';
part 'apply_leave_state.dart';

class ApplyLeaveCubit extends Cubit<ApplyLeaveState> {
  ApplyLeaveCubit() : super(ApplyLeaveInitial());

  TextEditingController toController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  String? startDate;
  String? endDate;
  int? total;
  final formKey = GlobalKey<FormState>();
  ApiHandle apiHandle = ApiHandle();
  Future<void> postApplication(BuildContext context) async {
    try {
      emit(ApplyLeaveLoading());

      if (startDate == null || endDate == null) {
        throw Exception("Start date or end date is missing");
      }

      // Calculate total days
      DateTime start = DateTime.parse("$startDate");
      DateTime end = DateTime.parse("$endDate");
      int totalDays = end.difference(start).inDays + 1;

      final leveApplicationData = {
        'to': [toController.text.trim()],
        'from': fromController.text.trim(),
        'subject': subjectController.text.trim(),
        'reason': reasonController.text.trim(),
        'startDate': startDate,
        'endDate': endDate,
        'days': totalDays,
      };

      print(leveApplicationData);
      await apiHandle.uploadLeaveApplication(leveApplicationData);

      if (!context.mounted) return;
      Snackbar.successSnackbar(
        context,
        title: 'Success!',
        icon: FontAwesomeIcons.squareCheck,
        message: "Your application Submitted",
      );
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      emit(ApplyLeaveLoaded());
      Snackbar.warningSnackbar(context, title: 'Failed!', message: 'Try again');
      emit(ApplyLeaveError(e.toString()));
    }
  }
}
