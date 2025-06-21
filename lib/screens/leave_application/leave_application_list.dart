import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/application_card/leave_application_card.dart';
import 'package:protask/cubit/check_leave_status/check_leave_status_cubit.dart';
import 'package:protask/cubit/update_leave_status/update_leave_status_cubit.dart';
import 'package:protask/screens/leave_application/leave_application_status_change.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class LeaveApplicationList extends StatelessWidget {
  final bool? ismanager;
  const LeaveApplicationList({this.ismanager, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(
            child: BlocBuilder<CheckLeaveStatusCubit, CheckLeaveStatusState>(
              builder: (context, state) {
                if (state is CheckLeaveStatusLoading) {
                  return _buildLoadingState();
                } else if (state is CheckLeaveStatusError) {
                  return _buildErrorState(context, state.message);
                } else if (state is CheckLeaveStatusLoaded) {
                  final filteredApplications = state.filteredApplications;
                  return _buildApplicationsList(context, filteredApplications);
                }
                return _buildErrorState(context, "Something went wrong!");
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ismanager == true ? "Leave Applications" : "Your Applications",
                style: TextStyle(
                  color: MyColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ismanager == true
                    ? 'Manage team leave requests'
                    : 'Track your leave status',
                style: TextStyle(
                  color: MyColor.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Add refresh functionality
            context.read<CheckLeaveStatusCubit>().fetchLeaveApplication();
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    ismanager == true
                        ? [Colors.purple.shade400, Colors.purple.shade600]
                        : [Colors.blue.shade400, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              ismanager == true
                  ? FontAwesomeIcons.userTie
                  : FontAwesomeIcons.user,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ismanager == true ? 'Manager Dashboard' : 'My Applications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  ismanager == true
                      ? 'Review and manage leave requests from your team'
                      : 'View the status of your submitted leave applications',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
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
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading applications...',
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

  Widget _buildErrorState(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CheckLeaveStatusCubit>().fetchLeaveApplication();
      },
      color: Colors.blue.shade600,
      child: SingleChildScrollView(
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
                  context.read<CheckLeaveStatusCubit>().fetchLeaveApplication();
                },
                icon: const Icon(FontAwesomeIcons.arrowRotateLeft, size: 16),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationsList(
    BuildContext context,
    List filteredApplications,
  ) {
    if (filteredApplications.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CheckLeaveStatusCubit>().fetchLeaveApplication();
      },
      color: Colors.blue.shade600,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Applications count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.fileLines,
                    color: Colors.blue.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${filteredApplications.length} ${filteredApplications.length == 1 ? 'Application' : 'Applications'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Applications list
            Expanded(
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: filteredApplications.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  final application = filteredApplications[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: LeaveApplicationCard(
                      appoveDate: application['updated'].toString(),
                      sentDate: application['created'].toString(),
                      subject: application['subject'],
                      status: application['status'],
                      description: application['reason'],
                      onTap:
                          (ismanager == true)
                              ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BlocProvider(
                                          create:
                                              (context) =>
                                                  UpdateLeaveStatusCubit(),
                                          child: LeaveApplicationStatusChange(
                                            createdDate:
                                                application['created']
                                                    .toString(),
                                            from: application['from'],
                                            id: application['id'],
                                            reason: application['reason'],
                                            subject: application['subject'],
                                            status: application['status'],
                                          ),
                                        ),
                                  ),
                                );
                              }
                              : () {}, // Provide empty function instead of null
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CheckLeaveStatusCubit>().fetchLeaveApplication();
      },
      color: Colors.blue.shade600,
      child: SingleChildScrollView(
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
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  ismanager == true
                      ? FontAwesomeIcons.folderOpen
                      : FontAwesomeIcons.calendarXmark,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Applications Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ismanager == true
                    ? 'No leave applications have been submitted by your team yet'
                    : 'You haven\'t submitted any leave applications yet',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<CheckLeaveStatusCubit>().fetchLeaveApplication();
                },
                icon: const Icon(FontAwesomeIcons.arrowRotateLeft, size: 16),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
