import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/button/status_menu_button.dart';
import 'package:protask/component/task_card/task_card.dart';
import 'package:protask/cubit/user_task_list/user_task_list_cubit.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class UsersTasks extends StatefulWidget {
  final int userId;
  final String userName;
  const UsersTasks({super.key, required this.userId, required this.userName});

  @override
  State<UsersTasks> createState() => _UsersTasksState();
}

class _UsersTasksState extends State<UsersTasks> {
  String selectedStatus = "In Progress";
  final ScrollController _scrollController = ScrollController();
  bool _showStats = true;

  @override
  void initState() {
    super.initState();
    context.read<UserTaskListCubit>().fetchUserTasks(widget.userId);
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
      if (shouldShow != _showStats) {
        setState(() {
          _showStats = shouldShow;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showStats ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showStats ? 1.0 : 0.0,
              child:
                  _showStats ? _buildHeaderSection() : const SizedBox.shrink(),
            ),
          ),
          _buildStatusTabs(),
          Expanded(
            child: BlocBuilder<UserTaskListCubit, UserTaskListState>(
              builder: (context, state) {
                if (state is UserTaskListLoading) {
                  return _buildLoadingState();
                } else if (state is UserTaskListError) {
                  return _buildErrorState(state.message);
                } else if (state is UserTaskListLoaded) {
                  final filteredTasks =
                      state.userTasks
                          .where((task) => task['status'] == selectedStatus)
                          .toList();
                  return _buildTasksList(filteredTasks);
                }
                return _buildErrorState("Something went wrong!");
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: MyColor.darkBlue,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            FontAwesomeIcons.arrowLeft,
            color: MyColor.white,
            size: 18,
          ),
        ),
      ),
      title: Row(
        children: [
         
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: MyColor.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Task Overview',
                  style: TextStyle(
                    color: MyColor.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<UserTaskListCubit>().fetchUserTasks(widget.userId);
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              FontAwesomeIcons.arrowRotateRight,
              color: MyColor.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocBuilder<UserTaskListCubit, UserTaskListState>(
        builder: (context, state) {
          if (state is UserTaskListLoaded) {
            final allTasks = state.userTasks;
            final todoCount =
                allTasks.where((task) => task['status'] == 'To Do').length;
            final inProgressCount =
                allTasks
                    .where((task) => task['status'] == 'In Progress')
                    .length;
            final doneCount =
                allTasks.where((task) => task['status'] == 'Done').length;
            final totalTasks = allTasks.length;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Tasks',
                        totalTasks.toString(),
                        FontAwesomeIcons.listCheck,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Completed',
                        doneCount.toString(),
                        FontAwesomeIcons.circleCheck,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'In Progress',
                        inProgressCount.toString(),
                        FontAwesomeIcons.clock,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'To Do',
                        todoCount.toString(),
                        FontAwesomeIcons.circle,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatusTab(
                "To Do",
                FontAwesomeIcons.circle,
                Colors.red,
              ),
            ),
            Expanded(
              child: _buildStatusTab(
                "In Progress",
                FontAwesomeIcons.clock,
                Colors.orange,
              ),
            ),
            Expanded(
              child: _buildStatusTab(
                "Done",
                FontAwesomeIcons.circleCheck,
                Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab(String status, IconData icon, Color color) {
    final isSelected = selectedStatus == status;
    return GestureDetector(
      onTap: () => setState(() => selectedStatus = status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? MyColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: 14,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                status,
                style: TextStyle(
                  color:
                      isSelected ? Colors.grey.shade800 : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List filteredTasks) {
    if (filteredTasks.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserTaskListCubit>().fetchUserTasks(widget.userId);
      },
      color: MyColor.darkBlue,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredTasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return Container(
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TaskCard(
                taskName: task['title'],
                dueDate: task['dueDate'],
                createdDate: task['createdDate'],
                status: task['status'],
                description: task['description'],
                projectName: task['projectName'],
                onTap: () {
                  // Handle task click
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MyColor.darkBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MyColor.darkBlue),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading ${widget.userName}\'s tasks...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    IconData statusIcon;
    Color statusColor;
    String message;

    switch (selectedStatus) {
      case "To Do":
        statusIcon = FontAwesomeIcons.circle;
        statusColor = Colors.red;
        message = "No tasks to do";
        break;
      case "In Progress":
        statusIcon = FontAwesomeIcons.clock;
        statusColor = Colors.orange;
        message = "No tasks in progress";
        break;
      case "Done":
        statusIcon = FontAwesomeIcons.circleCheck;
        statusColor = Colors.green;
        message = "No completed tasks";
        break;
      default:
        statusIcon = FontAwesomeIcons.listCheck;
        statusColor = Colors.grey;
        message = "No tasks available";
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, size: 48, color: statusColor),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.userName} has no $selectedStatus tasks at the moment',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              FontAwesomeIcons.triangleExclamation,
              size: 48,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<UserTaskListCubit>().fetchUserTasks(widget.userId);
            },
            icon: const Icon(FontAwesomeIcons.arrowRotateLeft, size: 16),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColor.darkBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
