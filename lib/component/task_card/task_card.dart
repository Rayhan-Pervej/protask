import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protask/component/task_card/line_breaker.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String dueDate;
  final String createdDate;
  final String status;
  final String description;
  final String projectName;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.taskName,
    required this.dueDate,
    required this.onTap,
    required this.createdDate,
    required this.status,
    required this.description,
    required this.projectName,
  });

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat("d MMM").format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: MyColor.gray,
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(taskName, style: TextDesign().taskName.copyWith(fontSize: 18)),

            Text(
              "Project: $projectName",
              style: TextDesign().taskName.copyWith(
                fontSize: 14,
                color: MyColor.gray,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: MyColor.darkBlue,
                ),
                const SizedBox(width: 5),
                Text(
                  "Status: $status",
                  style: TextDesign().bodyText.copyWith(
                    color: MyColor.darkBlue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            CustomEllipsisText(text: description, style: TextDesign().bodyText),

            SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: MyColor.red),
                const SizedBox(width: 5),
                Text(
                  "Due: ${formatDate(dueDate)}",
                  style: const TextStyle(fontSize: 12, color: MyColor.red),
                ),
                const Spacer(),
                Icon(Icons.date_range, size: 16, color: MyColor.softBlue),
                const SizedBox(width: 5),
                Text(
                  "Created: ${formatDate(createdDate)}",
                  style: TextStyle(fontSize: 12, color: MyColor.softBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
