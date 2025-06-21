import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/input_widget/date_time_field.dart';
import 'package:protask/component/input_widget/input_field.dart';
import 'package:protask/component/input_widget/multiline_input_field.dart';
import 'package:protask/cubit/apply_leave/apply_leave_cubit.dart';
import 'package:protask/services/validators.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplyLeaveCubit>();
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
      backgroundColor: Colors.indigo.shade600,
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
            color: Colors.white,
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
                'Apply for Leave',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Submit your leave request',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
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
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              FontAwesomeIcons.calendarDays,
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
                  'Leave Application',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Fill out the form below to request time off',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(ApplyLeaveCubit cubit) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        key: cubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Request Details', FontAwesomeIcons.fileLines),
            const SizedBox(height: 16),

            // Email Fields
            _buildFieldContainer(
              child: InputField(
                controller: cubit.toController,
                fieldLabel: "To (Supervisor)",
                backgroundColor: Colors.white,
                hintText: 'supervisor@company.com',
                validation: true,
                validatorClass: ValidatorsClass().validateSupervisorEmail,
                errorMessage: "",
                inputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
            ),

            const SizedBox(height: 16),

            _buildFieldContainer(
              child: InputField(
                controller: cubit.fromController,
                fieldLabel: "From (Your Email)",
                backgroundColor: Colors.white,
                hintText: 'your.email@company.com',
                validation: true,
                errorMessage: "",
                validatorClass: ValidatorsClass().validateEmail,
                inputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
            ),

            const SizedBox(height: 16),

            _buildFieldContainer(
              child: InputField(
                controller: cubit.subjectController,
                fieldLabel: "Subject",
                backgroundColor: Colors.white,
                hintText: 'Leave Request - [Your Name]',
                validation: true,
                errorMessage: "",
                validatorClass: ValidatorsClass().validateSubject,
                textInputAction: TextInputAction.next,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Leave Details', FontAwesomeIcons.calendar),
            const SizedBox(height: 16),

            // Date Selection
            _buildFieldContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.calendarCheck,
                        color: Colors.blue.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Leave Duration',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // Desktop/Tablet Layout
                        return Row(
                          children: [
                            Expanded(child: _buildDateField(cubit, true)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildDateField(cubit, false)),
                          ],
                        );
                      } else {
                        // Mobile Layout
                        return Column(
                          children: [
                            _buildDateField(cubit, true),
                            const SizedBox(height: 16),
                            _buildDateField(cubit, false),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Reason Field
            _buildFieldContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.noteSticky,
                        color: Colors.orange.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reason for Leave',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  MultilineInputField(
                    controller: cubit.reasonController,
                    fieldLabel: 'Detailed Reason',
                    backgroundColor: Colors.white,
                    hintText:
                        'Please provide a detailed reason for your leave request...',
                    validation: true,
                    validatorClass: ValidatorsClass().validateLeaveReason,
                    errorMessage: '',
                    numberOfLines: 5,
                    needTitle: false,
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

  Widget _buildDateField(ApplyLeaveCubit cubit, bool isStartDate) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DateTimeFormField(
        type: DateTimePickerType.date,
        label: isStartDate ? 'Start Date' : 'End Date',
        initialValue: isStartDate ? cubit.startDate : cubit.endDate,
        onChanged: (value) {
          safeSetState(() {
            if (isStartDate) {
              cubit.startDate = value;
            } else {
              cubit.endDate = value;
            }
          });
        },
        validator: (value) => ValidatorsClass().validateTaskTime(value),
      ),
    );
  }

  Widget _buildSubmitButton(ApplyLeaveCubit cubit) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<ApplyLeaveCubit, ApplyLeaveState>(
        builder: (context, state) {
          bool isLoading = state is ApplyLeaveLoading;

          return ElevatedButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      if (cubit.formKey.currentState!.validate()) {
                        cubit.postApplication(context);
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
                  isLoading ? Colors.grey.shade300 : Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isLoading ? 0 : 2,
            ),
            child:
                isLoading
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Submitting Request...",
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
                          FontAwesomeIcons.paperPlane,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Submit Leave Request",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
