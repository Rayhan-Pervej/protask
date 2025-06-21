import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/theme/my_color.dart';

class StatusTabs extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const StatusTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              child: StatusTab(
                status: "To Do",
                icon: FontAwesomeIcons.circle,
                color: Colors.red,
                isSelected: selectedStatus == "To Do",
                onTap: () => onStatusChanged("To Do"),
              ),
            ),
            Expanded(
              child: StatusTab(
                status: "In Progress",
                icon: FontAwesomeIcons.clock,
                color: Colors.orange,
                isSelected: selectedStatus == "In Progress",
                onTap: () => onStatusChanged("In Progress"),
              ),
            ),
            Expanded(
              child: StatusTab(
                status: "Done",
                icon: FontAwesomeIcons.circleCheck,
                color: Colors.green,
                isSelected: selectedStatus == "Done",
                onTap: () => onStatusChanged("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTab extends StatelessWidget {
  final String status;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const StatusTab({
    super.key,
    required this.status,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? MyColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
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
                  color: isSelected ? Colors.grey.shade800 : Colors.grey.shade600,
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
}