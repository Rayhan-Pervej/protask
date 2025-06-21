import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/input_widget/input_field.dart';
import 'package:protask/component/input_widget/password_field.dart';
import 'package:protask/cubit/auth/auth_cubit.dart';
import 'package:protask/services/validators.dart';
import 'package:protask/theme/my_color.dart';
import 'package:protask/theme/text_design.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Header Section
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // Login Form Card
                  _buildLoginCard(authCubit, context),

                  const SizedBox(height: 32),

                  // Footer Section
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Logo/Icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            FontAwesomeIcons.tasks,
            color: Colors.white,
            size: 32,
          ),
        ),

        const SizedBox(height: 24),

        // Welcome Text
        Text(
          "Welcome back!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Sign in to your Pro Task account",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(AuthCubit authCubit, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Login Form Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FontAwesomeIcons.rightToBracket,
                  color: Colors.blue.shade600,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Login Form
          _buildForm(authCubit),

          const SizedBox(height: 24),

          // Login Button
          _buildLoginButton(context),

          const SizedBox(height: 16),

          // Forgot Password
          _buildForgotPassword(),
        ],
      ),
    );
  }

  Widget _buildForm(AuthCubit authCubit) {
    return Form(
      key: authCubit.formkey,
      child: Column(
        children: [
          // Email Field
          InputField(
            controller: authCubit.emailController,
            fieldLabel: "Email Address",
            backgroundColor: Colors.white,
            hintText: "Enter your email address",
            validation: true,
            errorMessage: "",
            validatorClass: ValidatorsClass().validateEmail,
            inputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          // Password Field
          PasswordField(
            password: authCubit.passwordController,
            fieldLabel: "Password",
            hintText: "Enter your password",
            backgroundColor: Colors.white,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                state.isLoading
                    ? null
                    : () {
                      if (context
                          .read<AuthCubit>()
                          .formkey
                          .currentState!
                          .validate()) {
                        context.read<AuthCubit>().login(context);
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  state.isLoading ? Colors.grey.shade300 : Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: state.isLoading ? 0 : 2,
              shadowColor: Colors.blue.withOpacity(0.3),
            ),
            child:
                state.isLoading
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
                          "Signing in...",
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
                        const Icon(FontAwesomeIcons.rightToBracket, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Add forgot password functionality
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.key, size: 14, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              "Forgot your password?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          // Divider
          Row(
            children: [
              Expanded(
                child: Container(height: 1, color: Colors.grey.shade300),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Pro Task",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(height: 1, color: Colors.grey.shade300),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Version/Copyright
          Text(
            "© 2024 Pro Task. All rights reserved.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
