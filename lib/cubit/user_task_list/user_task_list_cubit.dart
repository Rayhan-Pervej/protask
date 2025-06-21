import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';

part 'user_task_list_state.dart';

class UserTaskListCubit extends Cubit<UserTaskListState> {
  final ApiHandle apiHandle;
  UserTaskListCubit(this.apiHandle) : super(UserTaskListLoading());

  Future<void> fetchUserTasks(int userId) async {
    try {
      final userTasks = await apiHandle.getUserTasks(userId);
      print (userTasks);
      final List<Map<String, dynamic>> filteredUserTasks = userTasks.map((userTask) {
        final createdDateStr = userTask['created_at'] ?? '';  
        final createdDate = DateTime.tryParse(createdDateStr) ?? DateTime(0);

        return {
          'title':userTask['title'] ==null?  " No title" : userTask['title'] ?? " ",
          'description': userTask['description'] ?? 'No description available',
          'status':userTask['list'] ==null? " No status ": userTask['list']['title'] ?? 'unavailable',
          'dueDate': userTask['due_date'] ?? '',
          'createdDate': createdDateStr,  
          'createdDateParsed': createdDate, 
          'projectName': userTask['project']['title'] ?? '',
        };
      }).toList(growable: false); 

      filteredUserTasks.sort((a, b) => (b['createdDateParsed'] as DateTime).compareTo(a['createdDateParsed'] as DateTime));

      for (var task in filteredUserTasks) {
        task.remove('createdDateParsed');
      }

      emit(UserTaskListLoaded(filteredUserTasks));
    } catch (e) {
      emit(UserTaskListError(e.toString()));
    }
  }
}
