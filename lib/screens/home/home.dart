import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/cubit/add_task/add_task_cubit.dart';
import 'package:protask/cubit/auth/auth_cubit.dart';
import 'package:protask/cubit/my_task_list/my_task_list_cubit.dart';
import 'package:protask/cubit/user_list/userlist_cubit.dart';
import 'package:protask/screens/home/widgets/header_section.dart';
import 'package:protask/screens/home/widgets/loading_state.dart';
import 'package:protask/screens/home/widgets/status_tab.dart';
import 'package:protask/screens/home/widgets/task_list.dart';
import 'package:protask/screens/tasks/add_task.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedStatus = "In Progress";
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final shouldShow = _scrollController.offset <= 50;
      if (shouldShow != _showHeader) {
        setState(() {
          _showHeader = shouldShow;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocListener<MyTaskListCubit, MyTaskListState>(
          listener: _handleBlocListener,
          child: Column(
            children: [
              // Header Section with Welcome Message
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showHeader ? null : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showHeader ? 1.0 : 0.0,
                  child: _showHeader
                      ? const HeaderSection()
                      : const SizedBox.shrink(),
                ),
              ),

              // Status Tabs
              StatusTabs(
                selectedStatus: selectedStatus,
                onStatusChanged: (status) => setState(() => selectedStatus = status),
              ),

              // Task List
              Expanded(
                child: BlocBuilder<MyTaskListCubit, MyTaskListState>(
                  builder: (context, state) {
                    if (state is MyTaskListLoading || state is TaskStatusUpdating) {
                      return const LoadingState();
                    } else if (state is MyTaskListError) {
                      return ErrorState(message: state.message);
                    } else if (state is MyTaskListLoaded) {
                      final filteredTasks = state.tasks
                          .where((task) => task['status'] == selectedStatus)
                          .toList();
                      return TasksList(
                        filteredTasks: filteredTasks,
                        scrollController: _scrollController,
                        selectedStatus: selectedStatus,
                        onCreateTask: _navigateToAddTask,
                      );
                    } else if (state is UpdateTaskStatusSuccess) {
                      // After successful update, refetch tasks to show updated data
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<MyTaskListCubit>().fetchTasks();
                      });
                      return const LoadingState();
                    }
                    return const ErrorState(message: "Something went wrong!");
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  void _handleBlocListener(BuildContext context, MyTaskListState state) {
    if (state is UpdateTaskStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                FontAwesomeIcons.circleCheck,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.message,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (state is MyTaskListError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.message,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _navigateToAddTask,
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(FontAwesomeIcons.plus, size: 18),
      label: const Text(
        'New Task',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => UserlistCubit(ApiHandle())..fetchUsers(),
            ),
            BlocProvider(create: (context) => AddTaskCubit(ApiHandle())),
            BlocProvider(
              create: (context) => AddTaskCubit(ApiHandle())..fetchProjects(),
            ),
          ],
          child: AddTask(),
        ),
      ),
    );
  }
}