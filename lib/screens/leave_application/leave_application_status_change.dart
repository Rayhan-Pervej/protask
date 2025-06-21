import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:protask/cubit/update_leave_status/update_leave_status_cubit.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class LeaveApplicationStatusChange extends StatelessWidget {
  final String subject;
  final String from;
  final String reason;
  final String createdDate;
  final int id;
  final String? status; // Add status parameter

  const LeaveApplicationStatusChange({
    super.key,
    required this.subject,
    required this.from,
    required this.id,
    required this.reason,
    required this.createdDate,
    this.status, // Optional status parameter
  });

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat("d MMM yyyy").format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  // Helper method to check if application is processed
  bool get isProcessed =>
      status?.toLowerCase() == 'approved' ||
      status?.toLowerCase() == 'rejected';

  // Helper method to get status information
  Map<String, dynamic> getStatusInfo() {
    switch (status?.toLowerCase()) {
      case 'approved':
        return {
          'text': 'Approved',
          'icon': FontAwesomeIcons.check,
          'color': Colors.green,
          'bgColor': Colors.green.shade50,
          'borderColor': Colors.green.shade200,
        };
      case 'rejected':
        return {
          'text': 'Rejected',
          'icon': FontAwesomeIcons.xmark,
          'color': Colors.red,
          'bgColor': Colors.red.shade50,
          'borderColor': Colors.red.shade200,
        };
      default:
        return {
          'text': 'Pending Review',
          'icon': FontAwesomeIcons.clock,
          'color': Colors.orange,
          'bgColor': Colors.orange.shade50,
          'borderColor': Colors.orange.shade200,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isProcessed ? 'Leave Application' : 'Review Application',
              style: TextStyle(
                color: MyColor.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isProcessed ? 'Application details' : 'Pending manager review',
              style: TextStyle(
                color: MyColor.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card with Application Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusInfo()['bgColor'],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: getStatusInfo()['borderColor'],
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                getStatusInfo()['icon'],
                                size: 12,
                                color: getStatusInfo()['color'].shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                getStatusInfo()['text'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: getStatusInfo()['color'].shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Subject
                        Text(
                          'Leave Request',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Employee and date info
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                icon: FontAwesomeIcons.user,
                                label: 'Requested by',
                                value: from,
                                iconColor: Colors.blue.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoItem(
                                icon: FontAwesomeIcons.calendar,
                                label: 'Submitted on',
                                value: formatDate(createdDate),
                                iconColor: Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reason Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidMessage,
                              size: 18,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Reason for Leave',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Simple divider
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          reason,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons - Only show if not processed
          if (!isProcessed)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BlocBuilder<
                UpdateLeaveStatusCubit,
                UpdateLeaveStatusState
              >(
                builder: (context, state) {
                  bool isLoading = state is UpdateLeaveStatusLoading;

                  return Column(
                    children: [
                      Text(
                        'Review this leave application',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          // Reject Button
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              label: 'Reject',
                              icon: FontAwesomeIcons.xmark,
                              color: Colors.red,
                              isLoading: isLoading,
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        _showConfirmationDialog(
                                          context,
                                          'Reject Application',
                                          'Are you sure you want to reject this leave application?',
                                          Colors.red,
                                          () {
                                            context
                                                .read<UpdateLeaveStatusCubit>()
                                                .updateStatus("rejected");
                                          },
                                        );
                                      },
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Approve Button
                          Expanded(
                            child: _buildActionButton(
                              context: context,
                              label: 'Approve',
                              icon: FontAwesomeIcons.check,
                              color: MyColor.darkBlue,
                              isLoading: isLoading,
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        _showConfirmationDialog(
                                          context,
                                          'Approve Application',
                                          'Are you sure you want to approve this leave application?',
                                          Colors.green,
                                          () {
                                            context
                                                .read<UpdateLeaveStatusCubit>()
                                                .updateStatus("approved");
                                          },
                                        );
                                      },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

          // Status message for processed applications
          if (isProcessed)
            Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: getStatusInfo()['bgColor'],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: getStatusInfo()['borderColor']),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      getStatusInfo()['icon'],
                      color: getStatusInfo()['color'],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'This application has been ${getStatusInfo()['text'].toLowerCase()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: getStatusInfo()['color'].shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    Color color,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
