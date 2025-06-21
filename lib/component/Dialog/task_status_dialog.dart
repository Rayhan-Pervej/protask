import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class TaskStatusDialog extends StatelessWidget {
  final String currentStatus;
  final String taskName;
  final String description;
  final String projectName;
  final String dueDate;
  final String createdDate;
  final Function(String) onStatusChanged;

  const TaskStatusDialog({
    super.key,
    required this.currentStatus,
    required this.taskName,
    required this.description,
    required this.projectName,
    required this.dueDate,
    required this.createdDate,
    required this.onStatusChanged,
  });

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat("d MMM yyyy").format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MyColor.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FontAwesomeIcons.listCheck,
                      color: MyColor.darkBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Task Details',
                      style: TextDesign().taskName.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: MyColor.gray, size: 20),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Task Information Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Name
                    Text(
                      taskName,
                      style: TextDesign().taskName.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Project Name
                    Row(
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 16,
                          color: MyColor.darkBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Project: $projectName',
                          style: TextDesign().bodyText.copyWith(
                            fontSize: 14,
                            color: MyColor.darkBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      'Description:',
                      style: TextDesign().bodyText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextDesign().bodyText.copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Dates Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: MyColor.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Due Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColor.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatDate(dueDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: MyColor.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: 14,
                                    color: MyColor.softBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Created',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: MyColor.softBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatDate(createdDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: MyColor.softBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Current Status Indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(currentStatus).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(currentStatus),
                      color: _getStatusColor(currentStatus),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current: $currentStatus',
                      style: TextDesign().bodyText.copyWith(
                        color: _getStatusColor(currentStatus),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Options Title
              Text(
                'Change status to:',
                style: TextDesign().bodyText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Status Buttons - Smaller and more compact
              Row(
                children: [
                  Expanded(
                    child: _buildCompactStatusOption(
                      context,
                      'To Do',
                      FontAwesomeIcons.circle,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCompactStatusOption(
                      context,
                      'In Progress',
                      FontAwesomeIcons.clock,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCompactStatusOption(
                      context,
                      'Done',
                      FontAwesomeIcons.circleCheck,
                      Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextDesign().bodyText.copyWith(
                      color: MyColor.gray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStatusOption(
    BuildContext context,
    String status,
    IconData icon,
    Color color,
  ) {
    final isCurrentStatus = status == currentStatus;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            isCurrentStatus
                ? null
                : () {
                  Navigator.of(context).pop();
                  onStatusChanged(status);
                },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color:
                isCurrentStatus
                    ? MyColor.white.withOpacity(0.5)
                    : color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isCurrentStatus
                      ? MyColor.gray.withOpacity(0.3)
                      : color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      isCurrentStatus
                          ? MyColor.gray.withOpacity(0.2)
                          : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: isCurrentStatus ? MyColor.gray : color,
                  size: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                status,
                style: TextDesign().bodyText.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isCurrentStatus ? MyColor.gray : color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isCurrentStatus) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: MyColor.gray.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Current',
                    style: TextDesign().bodyText.copyWith(
                      fontSize: 8,
                      color: MyColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'To Do':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Done':
        return Colors.green;
      default:
        return MyColor.softBlue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'To Do':
        return FontAwesomeIcons.circle;
      case 'In Progress':
        return FontAwesomeIcons.clock;
      case 'Done':
        return FontAwesomeIcons.circleCheck;
      default:
        return FontAwesomeIcons.listCheck;
    }
  }
}
