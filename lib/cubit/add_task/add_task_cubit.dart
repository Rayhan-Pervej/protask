import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/snackbar/snackbar.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final ApiHandle apiHandle;

  List<int> selectedUserIds = [];
  List<dynamic> projects = [];
  List<dynamic> boards = [];

  List<Map<String, dynamic>> filteredProjects = [];
  List<Map<String, dynamic>> filteredBoards = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? selectedProjectId;
  int? selectedBoardId;
  String? datetime;
  bool recurring = false;

  final formkey = GlobalKey<FormState>();

  AddTaskCubit(this.apiHandle) : super(AddTaskInitial());

  void updateSelectedUsers(List<int> userIds) {
    selectedUserIds = userIds;
    emit(
      AddTaskLoaded(
        filteredProjects,
        filteredBoards,
        selectedProjectId,
        selectedBoardId,
      ),
    );
  }

  Future<void> fetchProjects() async {
    emit(AddTaskLoading());
    try {
      final fetchedProjects = await apiHandle.getAllProjects();
      projects = fetchedProjects;
      filteredProjects =
          projects.map((p) {
            return {'title': p['title'], 'id': p['id']};
          }).toList();

      emit(
        AddTaskLoaded(
          filteredProjects,
          filteredBoards,
          selectedProjectId,
          selectedBoardId,
        ),
      );
    } catch (e) {
      emit(AddTaskError("Failed to load projects: ${e.toString()}"));
    }
  }

  Future<void> fetchBoards(int projectId) async {
    selectedProjectId = projectId;
    selectedBoardId = null;
    emit(AddTaskLoading());

    try {
      final fetchedBoards = await apiHandle.getBoardList(projectId);
      boards = fetchedBoards;
      filteredBoards =
          boards.map((b) {
            return {'title': b['title'], 'id': b['id']};
          }).toList();

      emit(
        AddTaskLoaded(
          filteredProjects,
          filteredBoards,
          selectedProjectId,
          selectedBoardId,
        ),
      );
    } catch (e) {
      emit(AddTaskError("Failed to load boards: ${e.toString()}"));
    }
  }

  void selectProject(int projectId) {
    selectedProjectId = projectId;
    selectedBoardId = null; // Reset board selection when project changes
    fetchBoards(projectId); // Fetch boards for the selected project
  }

  void selectBoard(int boardId) {
    selectedBoardId = boardId;
    emit(
      AddTaskLoaded(
        filteredProjects,
        filteredBoards,
        selectedProjectId,
        selectedBoardId,
      ),
    );
  }

  void postTask(BuildContext context) async {
    emit(
      AddTaskLoaded(
        filteredProjects, filteredBoards, selectedProjectId, selectedBoardId, isSubmitting: true,
      ),
    );
    try {
      String formattedDatetime =
          (datetime ?? "").isNotEmpty ? "${datetime!}:00" : "";

      final taskData = {
        "title": titleController.text, "description": descriptionController.text, "datetime": formattedDatetime,  "assignees": selectedUserIds,
        "project": selectedProjectId, "board": selectedBoardId, "recurring": recurring ? 1 : 0,
      };
      final response = await apiHandle.uploadTask(taskData);
      if (!context.mounted) return;
      Snackbar.successSnackbar( context,
        title: 'Success!',
        icon: FontAwesomeIcons.squareCheck,
        message: response['message'],
      );
      Navigator.pop(context);
    } catch (e) {
      emit(
        AddTaskLoaded(
          filteredProjects, filteredBoards, selectedProjectId, selectedBoardId, isSubmitting: false,
        ),
      );
      Snackbar.successSnackbar( context, title: 'Failed!', icon: FontAwesomeIcons.xmark, message: 'Try again',
      );
    }
  }
}
