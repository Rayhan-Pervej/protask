import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:protask/cubit/my_task_list/my_task_list_cubit.dart';
import 'package:protask/cubit/auth/auth_cubit.dart';
import 'package:protask/theme/my_color.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Iconsax.home_2, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'Here are your tasks for today',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Logout Button
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap:
                            authState.isLoading
                                ? null
                                : () => context
                                    .read<AuthCubit>()
                                    .showLogoutDialog(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child:
                              authState.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red.shade600,
                                      ),
                                    ),
                                  )
                                  : Icon(
                                    FontAwesomeIcons.rightFromBracket,
                                    color: Colors.red.shade600,
                                    size: 20,
                                  ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quick Stats
          BlocBuilder<MyTaskListCubit, MyTaskListState>(
            builder: (context, state) {
              if (state is MyTaskListLoaded) {
                final allTasks = state.tasks;
                final todoCount =
                    allTasks.where((task) => task['status'] == 'To Do').length;
                final inProgressCount =
                    allTasks
                        .where((task) => task['status'] == 'In Progress')
                        .length;
                final doneCount =
                    allTasks.where((task) => task['status'] == 'Done').length;
                final totalTasks = allTasks.length;

                return Row(
                  children: [
                    Expanded(
                      child: QuickStatCard(
                        label: 'Total',
                        value: totalTasks.toString(),
                        color: Colors.blue,
                        icon: FontAwesomeIcons.listCheck,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickStatCard(
                        label: 'Active',
                        value: inProgressCount.toString(),
                        color: Colors.orange,
                        icon: FontAwesomeIcons.clock,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickStatCard(
                        label: 'Done',
                        value: doneCount.toString(),
                        color: Colors.green,
                        icon: FontAwesomeIcons.circleCheck,
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const QuickStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
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
    );
  }
}
