import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/Dialog/task_status_dialog.dart';
import 'package:protask/component/task_card/task_card.dart';
import 'package:protask/cubit/my_task_list/my_task_list_cubit.dart';
import 'package:protask/theme/my_color.dart';

class TasksList extends StatelessWidget {
  final List filteredTasks;
  final ScrollController scrollController;
  final String selectedStatus;
  final VoidCallback onCreateTask;

  const TasksList({
    super.key,
    required this.filteredTasks,
    required this.scrollController,
    required this.selectedStatus,
    required this.onCreateTask,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredTasks.isEmpty) {
      return EmptyState(
        selectedStatus: selectedStatus,
        onCreateTask: onCreateTask,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MyTaskListCubit>().fetchTasks();
      },
      color: Colors.blue.shade600,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredTasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          padding: const EdgeInsets.only(bottom: 80), // Space for FAB
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
                onTap: () => _showTaskDialog(context, task),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTaskDialog(BuildContext context, Map task) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => TaskStatusDialog(
        currentStatus: task['status'],
        taskName: task['title'],
        description: task['description'],
        projectName: task['projectName'],
        dueDate: task['dueDate'],
        createdDate: task['createdDate'],
        onStatusChanged: (newStatus) async {
          try {
            // Show loading indicator
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Updating task status...'),
                  ],
                ),
                backgroundColor: Colors.blue.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(seconds: 2),
              ),
            );

            // Use the cubit to update task status with all required fields
            await context.read<MyTaskListCubit>().updateTaskStatus(
              taskId: task['id'],
              currentListId: task['list_id'],
              currentStatus: task['status'],
              targetStatus: newStatus,
              title: task['title'] ?? '',
              description: task['description'] ?? '',
              projectId: task['project_id'] ?? 1,
              dueDate: task['dueDate'] ?? '',
              userIds: (task['user_ids'] as List<int>?) ?? [1],
              isRecurring: task['is_recurring'] ?? 0,
            );
          } catch (e) {
            // Error handling is done in the BlocListener
            print('Error updating task status: $e');
          }
        },
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String selectedStatus;
  final VoidCallback onCreateTask;

  const EmptyState({
    super.key,
    required this.selectedStatus,
    required this.onCreateTask,
  });

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    String message;
    String subtitle;

    switch (selectedStatus) {
      case "To Do":
        statusIcon = FontAwesomeIcons.circle;
        statusColor = Colors.red;
        message = "No tasks to do";
        subtitle = "Great! You're all caught up";
        break;
      case "In Progress":
        statusIcon = FontAwesomeIcons.clock;
        statusColor = Colors.orange;
        message = "No active tasks";
        subtitle = "Ready to start something new?";
        break;
      case "Done":
        statusIcon = FontAwesomeIcons.circleCheck;
        statusColor = Colors.green;
        message = "No completed tasks";
        subtitle = "Complete some tasks to see them here";
        break;
      default:
        statusIcon = FontAwesomeIcons.listCheck;
        statusColor = Colors.grey;
        message = "No tasks available";
        subtitle = "Start by creating your first task";
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
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            if (selectedStatus != "Done") ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onCreateTask,
                icon: const Icon(FontAwesomeIcons.plus, size: 16),
                label: const Text('Create New Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}