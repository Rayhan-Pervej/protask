import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/button/dropdown/dropdown_button.dart';
import 'package:protask/component/button/dropdown/multi_select_dropdown.dart';
import 'package:protask/component/input_widget/date_time_field.dart';
import 'package:protask/component/input_widget/input_field.dart';
import 'package:protask/component/input_widget/multiline_input_field.dart';
import 'package:protask/cubit/add_task/add_task_cubit.dart';
import 'package:protask/cubit/user_list/userlist_cubit.dart';
import 'package:protask/services/validators.dart';
import 'package:protask/theme/my_color.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddTaskCubit>();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildHeaderSection(), _buildFormSection(cubit)],
        ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Task',
                style: TextStyle(
                  color: MyColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Fill in the details below',
                style: TextStyle(
                  color: MyColor.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FontAwesomeIcons.clipboardList,
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
                  'New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Create and assign a new task to team members',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(AddTaskCubit cubit) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: cubit.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Basic Information',
              FontAwesomeIcons.fileLines,
            ),
            const SizedBox(height: 16),

            // Title Field
            _buildFieldContainer(
              child: InputField(
                controller: cubit.titleController,
                fieldLabel: "Task Title",
                backgroundColor: Colors.grey.shade50,
                hintText: 'Enter task title...',
                validation: true,
                errorMessage: "",
                validatorClass: ValidatorsClass().validateTaskTitle,
              ),
            ),

            const SizedBox(height: 16),

            // Description Field
            _buildFieldContainer(
              child: MultilineInputField(
                controller: cubit.descriptionController,
                fieldLabel: 'Description',
                backgroundColor: Colors.grey.shade50,
                hintText: 'Enter task description...',
                validation: false,
                errorMessage: '',
                numberOfLines: 4,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(
              'Scheduling & Assignment',
              FontAwesomeIcons.calendar,
            ),
            const SizedBox(height: 16),

            // Date & Time and Project/Board
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Desktop/Tablet Layout
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildLeftColumn(cubit)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRightColumn()),
                    ],
                  );
                } else {
                  // Mobile Layout
                  return Column(
                    children: [
                      _buildLeftColumn(cubit),
                      const SizedBox(height: 16),
                      _buildRightColumn(),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Options', FontAwesomeIcons.gear),
            const SizedBox(height: 16),

            // Recurring Task Option
            _buildFieldContainer(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      FontAwesomeIcons.repeat,
                      color: Colors.orange.shade600,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recurring Task",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          "Enable if this task repeats regularly",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: cubit.recurring,
                    onChanged: (bool value) {
                      setState(() {
                        cubit.recurring = value;
                      });
                    },
                    activeColor: Colors.orange.shade600,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade600, size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildLeftColumn(AddTaskCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    color: Colors.blue.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Due Date & Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DateTimeFormField(
                type: DateTimePickerType.datetime,
                label: 'Select Date & Time',
                initialValue: cubit.datetime,
                onChanged: (value) {
                  setState(() {
                    cubit.datetime = value;
                  });
                },
                validator: (value) => ValidatorsClass().validateTaskTime(value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildFieldContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.users,
                    color: Colors.green.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Assign Team Members',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<UserlistCubit, UserlistState>(
                builder: (context, state) {
                  if (state is UserlistLoading) {
                    return _buildLoadingWidget();
                  } else if (state is UserlistError) {
                    return _buildErrorWidget(
                      "Error loading users: ${state.message}",
                    );
                  } else if (state is UserlistLoaded) {
                    final users = state.users;
                    return MultiSelectDropdown(
                      options:
                          users.map((user) => user['name'] as String).toList(),
                      selectedValues: [],
                      onChanged: (selectedNames) {
                        final selectedIds =
                            users
                                .where(
                                  (user) =>
                                      selectedNames.contains(user['name']),
                                )
                                .map<int>((user) => user['id'] as int)
                                .toList();
                        cubit.updateSelectedUsers(selectedIds);
                      },
                      validator: (List<String>? selectedNames) {
                        if (selectedNames == null || selectedNames.isEmpty) {
                          return "Assign at least one user.";
                        }
                        final selectedIds =
                            users
                                .where(
                                  (user) =>
                                      selectedNames.contains(user['name']),
                                )
                                .map<int>((user) => user['id'] as int)
                                .toList();
                        return ValidatorsClass().validateTaskAssign(
                          selectedIds,
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        if (state is AddTaskLoading) {
          return _buildLoadingWidget();
        } else if (state is AddTaskError) {
          return _buildErrorWidget("Error: ${state.message}");
        } else if (state is AddTaskLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.folderOpen,
                          color: Colors.purple.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Project',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown<int>(
                      validator: ValidatorsClass().validateTaskProject,
                      label: "Select Project",
                      hint: "Select Project",
                      value: state.selectedProjectId,
                      items:
                          state.projects
                              .map<DropdownMenuItem<int>>(
                                (project) => DropdownMenuItem<int>(
                                  value: project['id'],

                                  child: Text(
                                    project['title'].toString().length > 20
                                        ? "${project['title'].toString().substring(0, 20)}..."
                                        : project['title'].toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<AddTaskCubit>().selectProject(value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _buildFieldContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.tableCells,
                          color: Colors.orange.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Board',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown<int>(
                      label: "Select Board",
                      hint: "Select Board",
                      value: state.selectedBoardId,
                      validator: ValidatorsClass().validateTaskBoard,
                      items:
                          state.boards
                              .map<DropdownMenuItem<int>>(
                                (board) => DropdownMenuItem<int>(
                                  value: board['id'],
                                  child: Text(
                                    board['title'].toString().length > 20
                                        ? "${board['title'].toString().substring(0, 20)}..."
                                        : board['title'].toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<AddTaskCubit>().selectBoard(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red.shade600,
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AddTaskCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<AddTaskCubit, AddTaskState>(
        builder: (context, state) {
          bool isSubmitting =
              (state is AddTaskLoaded) ? state.isSubmitting : false;

          return ElevatedButton(
            onPressed:
                isSubmitting
                    ? null
                    : () {
                      if (cubit.formkey.currentState!.validate()) {
                        cubit.postTask(context);
                      } else {
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
                                const Text(
                                  "Please fill in all required fields.",
                                ),
                              ],
                            ),
                            backgroundColor: Colors.red.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSubmitting ? Colors.grey.shade300 : MyColor.yellow,
              foregroundColor: MyColor.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isSubmitting ? 0 : 2,
            ),
            child:
                isSubmitting
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MyColor.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Creating Task...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.plus,
                          size: 16,
                          color: MyColor.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Create Task",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: MyColor.black,
                          ),
                        ),
                      ],
                    ),
          );
        },
      ),
    );
  }
}
