import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Add this import
import 'package:protask/cubit/apply_leave/apply_leave_cubit.dart';
import 'package:protask/cubit/check_leave_status/check_leave_status_cubit.dart';
import 'package:protask/screens/leave_application/apply_leave.dart';
import 'package:protask/screens/leave_application/leave_application_list.dart';
import 'package:protask/services/client_config.dart/token_handle.dart';
import 'package:protask/theme/my_color.dart'; // Add your SharedPrefs import

class LeaveApplication extends StatelessWidget {
  const LeaveApplication({super.key});

  Future<bool> _checkIfManager() async {
    try {
      var token = await SharedPrefs().getToken();
      if (token != null && token.isNotEmpty) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        // Check if role exists and role id is 1 (Admin)
        if (decodedToken['role'] != null && decodedToken['role']['id'] == 1) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error decoding token: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkIfManager(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: MyColor.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Leave Management',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        bool ismanager = snapshot.data ?? false;

        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Leave Management',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            FontAwesomeIcons.calendarDays,
                            size: 32,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Manage Your Leaves',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ismanager
                              ? 'Apply for leave or review applications'
                              : 'Check your leave status',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Cards Section
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Apply for Leave Card (only for non-managers)
                  if (ismanager == false) ...[
                    _buildActionCard(
                      context: context,
                      icon: FontAwesomeIcons.solidPaperPlane,
                      title: 'Apply for Leave',
                      subtitle: 'Submit a new leave request',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider(
                                  create: (context) => ApplyLeaveCubit(),
                                  child: const ApplyLeave(),
                                ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Leave Applications/Status Card
                  _buildActionCard(
                    context: context,
                    icon: FontAwesomeIcons.circleExclamation,
                    title: ismanager ? 'Leave Applications' : 'Check Status',
                    subtitle:
                        ismanager
                            ? 'Review pending applications'
                            : 'View your leave status',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create:
                                    (context) =>
                                        CheckLeaveStatusCubit()
                                          ..fetchLeaveApplication(),
                                child: LeaveApplicationList(
                                  ismanager: ismanager,
                                ),
                              ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Leave History Card (commented out in original, but designed for future use)
                  _buildActionCard(
                    context: context,
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: 'Leave History',
                    subtitle: 'View past leave records',
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Implement leave history functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Leave History feature coming soon!'),
                        ),
                      );
                    },
                    isDisabled: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDisabled
                            ? Colors.grey.withOpacity(0.2)
                            : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isDisabled ? Colors.grey : color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isDisabled ? Colors.grey : Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              isDisabled
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FontAwesomeIcons.chevronRight,
                  color:
                      isDisabled ? Colors.grey.shade300 : Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
