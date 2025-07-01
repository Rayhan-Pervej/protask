import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';
import 'package:protask/services/client_config.dart/token_handle.dart';
part 'my_task_list_state.dart';

class MyTaskListCubit extends Cubit<MyTaskListState> {
  final ApiHandle apiHandle;
  MyTaskListCubit(this.apiHandle) : super(MyTaskListLoading());

  Future<void> fetchTasks() async {
    try {
      var token = await SharedPrefs().getToken();
      if (token == null) {
        emit(MyTaskListError('Token not found'));
        return;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      int userId = decodedToken['id'];

      final tasks = await apiHandle.getUserTasks(userId);

      final List<Map<String, dynamic>> filteredTasks = tasks
          .map((task) {
            final createdDateStr = task['created_at'] ?? '';
            final createdDate =
                DateTime.tryParse(createdDateStr) ?? DateTime(0);
            
            // Extract user IDs from assignees array
            List<int> userIds = [];
            if (task['assignees'] != null && task['assignees'] is List) {
              userIds = (task['assignees'] as List)
                  .map((assignee) => assignee['user_id'] as int)
                  .toList();
            }
            
            // If no assignees, use the main user_id as fallback
            if (userIds.isEmpty && task['user_id'] != null) {
              userIds = [task['user_id'] as int];
            }
            
            return {
              'title': task['title'] ?? '',
              'id': task['id'],
              'list_id': task['list']['id'],
              'project_id': task['project']['id'],
              'description': task['description'] ?? 'No description available',
              'status': task['list']['title'] ?? 'unavailable',
              'dueDate': task['due_date'] ?? '',
              'createdDate': createdDateStr,
              'createdDateParsed': createdDate,
              'projectName': task['project']['title'] ?? '',
              'is_recurring': task['is_recurring'] ?? 0,
              'user_ids': userIds.isNotEmpty ? userIds : [task['user_id'] ?? 1], // Ensure we always have at least one user
            };
          })
          .toList(growable: false);

      filteredTasks.sort(
        (a, b) => (b['createdDateParsed'] as DateTime).compareTo(
          a['createdDateParsed'] as DateTime,
        ),
      );

      for (var task in filteredTasks) {
        task.remove('createdDateParsed');
      }

      emit(MyTaskListLoaded(filteredTasks));
    } catch (e) {
      emit(MyTaskListError(e.toString()));
    }
  }

  // Map status names to their corresponding order values
  static const Map<String, int> statusToOrder = {
    'To Do': 1,
    'In Progress': 2,
    'Done': 3,
    'Stories': 0,
  };

  // Map order values to status names
  static const Map<int, String> orderToStatus = {
    0: 'Stories',
    1: 'To Do',
    2: 'In Progress',
    3: 'Done',
  };

  /// Calculates the list_id based on the current list_id and target status
  ///
  /// Logic: If current list_id is 282 (Done - order 3), then:
  /// - To Do (order 1): 282 - (3-1) = 280
  /// - In Progress (order 2): 282 - (3-2) = 281
  /// - Stories (order 0): 282 - (3-0) = 279
  int calculateListId(
    int currentListId,
    String currentStatus,
    String targetStatus,
  ) {
    try {
      final currentOrder = statusToOrder[currentStatus] ?? 0;
      final targetOrder = statusToOrder[targetStatus] ?? 0;

      final newListId = currentListId - (currentOrder - targetOrder);
      return newListId;
    } catch (e) {
      throw Exception('Invalid list_id: $currentListId');
    }
  }

  /// Updates task status by calculating the new list_id and calling the API
  Future<void> updateTaskStatus({
    required int taskId,
    required int currentListId,
    required String currentStatus,
    required String targetStatus,
    required String title,
    required String description,
    required int projectId,
    required String dueDate,
    required List<int> userIds,
    required int isRecurring,
  }) async {
    if (currentStatus == targetStatus) {
      emit(MyTaskListError('Task is already in $targetStatus status'));
      return;
    }

    emit(TaskStatusUpdating());

    try {
      final newListId = calculateListId(
        currentListId,
        currentStatus,
        targetStatus,
      );

      final response = await apiHandle.updateTaskStatus(
        taskId: taskId,
        title: title,
        description: description,
        listId: newListId,
        projectId: projectId,
        dueDate: dueDate,
        isRecurring: isRecurring,
        userIds: userIds,
      );

      emit(
        UpdateTaskStatusSuccess(
          message: response['message'] ?? 'Task status updated successfully',
          newStatus: targetStatus,
          newListId: newListId.toString(),
        ),
      );
    } catch (e) {
      emit(MyTaskListError('Failed to update task status: ${e.toString()}'));
    }
  }
}