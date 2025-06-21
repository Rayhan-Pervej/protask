import 'dart:convert';
import 'package:protask/services/client_config.dart/token_handle.dart';
import 'http_client.dart';

class ApiHandle {
  final HttpClient httpClient = HttpClient();
  final SharedPrefs sharedPrefs = SharedPrefs();

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    try {
      final response = await httpClient.request(
        endpoint: 'signin',
        method: 'POST',
        body: {'email': email, 'password': password},
      );

      final data = jsonDecode(response.body);
      if (data.containsKey("token")) {
        await sharedPrefs.saveToken(data["token"]); // Save token
      } else {
        throw Exception("Token not found in response");
      }

      return data;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<List<dynamic>> getAllUsers() async {
    try {
      final response = await httpClient.request(
        endpoint: 'all/users',
        method: 'GET',
        body: {"token": await SharedPrefs().getToken()},
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  Future<List<dynamic>> getUserTasks(int userId) async {
    var token = await SharedPrefs().getToken();
    try {
      final response = await httpClient.request(
        endpoint: 'user/$userId/task',
        method: "POST",
        body: {"token": token},
      );

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic> && data.containsKey("tasks")) {
        return data["tasks"] as List<dynamic>;
      } else {
        throw Exception("Unexpected response format: No 'tasks' key found");
      }
    } catch (e) {
      throw Exception('Failed to get user tasks: $e');
    }
  }

  Future<List<dynamic>> getUserLeaveApplications(int userId) async {
    try {
      final response = await httpClient.request(
        endpoint: 'leave-applications/$userId',
        method: 'GET',
        body: {'token': await SharedPrefs().getToken()},
      );

      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic> &&
          data.containsKey("leaveApplications")) {
        return data["leaveApplications"] as List<dynamic>;
      } else if (data is List) {
        return data;
      } else {
        throw Exception(
          "Unexpected response format: No 'leaveApplications' key found",
        );
      }
    } catch (e) {
      throw Exception('Failed to get user leave application: $e');
    }
  }

  Future<List<dynamic>> getAllProjects() async {
    try {
      final response = await httpClient.request(
        endpoint: 'projects',
        method: 'GET',
        body: {"token": await sharedPrefs.getToken()},
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch projects: $e');
    }
  }

  Future<List<dynamic>> getBoardList(projectId) async {
    try {
      final response = await httpClient.request(
        endpoint: 'boardlist/$projectId',
        method: 'GET',
        body: {"token": await sharedPrefs.getToken()},
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to fetch board list: $e');
    }
  }

  Future<Map<String, dynamic>> uploadTask(Map<String, dynamic> taskData) async {
    try {
      final response = await httpClient.request(
        endpoint: 'createtask',
        method: 'POST',
        body: {
          "token": await sharedPrefs.getToken(),
          "title": taskData["title"],
          "description": taskData["description"],
          "due_date": taskData["datetime"],
          "user_id": taskData["assignees"],
          "project_id": taskData["project"],
          "list_id": taskData["board"],
          "is_recurring": taskData["recurring"],
          "is_done": 0,
          "is_archive": 0,
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to upload task: $e');
    }
  }

  Future<Map<String, dynamic>> uploadLeaveApplication(
    Map<String, dynamic> leaveApplicationData,
  ) async {
    try {
      final response = await httpClient.request(
        endpoint: 'apply-leave',
        method: 'POST',
        body: {
          "token": await sharedPrefs.getToken(),
          "from": leaveApplicationData['from'],
          "to": leaveApplicationData['to'],
          "subject": leaveApplicationData['subject'],
          "reason": leaveApplicationData['reason'],
          "startDate": leaveApplicationData['startDate'],
          "endDate": leaveApplicationData['endDate'],
          "days": leaveApplicationData['days'],
        },
      );
      print("Raw response: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Failed to upload Application: $e');
    }
  }

Future<Map<String, dynamic>> updateTaskStatus({
    required int taskId,
    required String title,
    required String description,
    required int listId,
    required int projectId,
    required String dueDate,
    required int isRecurring,
    required List<int> userIds,
  }) async {
    print("Updating task ID: $taskId with list_id: $listId");
    try {
      final response = await httpClient.request(
        endpoint: 'task/update/$taskId',
        method: 'POST',
        body: {
          "token": await sharedPrefs.getToken(),
          "title": title,
          "description": description,
          "list_id": listId,
          "project_id": projectId,
          "due_date": dueDate,
          "is_recurring": isRecurring,
          "user_id": userIds, // Array of user IDs as expected by API
        },
      );

      print("Update response: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      print("Update error: ${e.toString()}");
      throw Exception('Failed to update task status: $e');
    }
  }
}
