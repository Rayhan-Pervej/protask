// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:protask/component/snackbar/snackbar.dart';
// import 'package:protask/screens/navbar.dart';
// import 'package:protask/services/client_config.dart/api_handle.dart';
// part 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   AuthCubit()
//     : super(AuthState(hasData: false, hasError: false, isLoading: false));
//   ApiHandle apiHandle = ApiHandle();

//   final formkey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   void login(BuildContext context) async {
//     emit(state.copyWith(true, false, false, null));
//     try {
//       await apiHandle.logIn(emailController.text, passwordController.text);

//       if (!context.mounted) return;
//       emit(state.copyWith(false, false, true, null));
//       Snackbar.successSnackbar(
//         context,
//         title: "Login Successful",
//         message: "welcome to Pro Task",
//         icon: FontAwesomeIcons.rightToBracket,
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Navbar()),
//       );
//     } catch (e) {
//       emit(state.copyWith(false, true, false, e.toString()));
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:protask/component/snackbar/snackbar.dart';
import 'package:protask/screens/login/login.dart';
import 'package:protask/screens/navbar.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';
import 'package:protask/services/client_config.dart/logout.dart';
import 'package:protask/services/client_config.dart/token_handle.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
    : super(AuthState(hasData: false, hasError: false, isLoading: false));

  ApiHandle apiHandle = ApiHandle();
  SharedPrefs sharedPrefs = SharedPrefs();

  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    emit(state.copyWith(true, false, false, null));
    try {
      await apiHandle.logIn(emailController.text, passwordController.text);

      if (!context.mounted) return;
      emit(state.copyWith(false, false, true, null));
      Snackbar.successSnackbar(
        context,
        title: "Login Successful",
        message: "welcome to Pro Task",
        icon: FontAwesomeIcons.rightToBracket,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    } catch (e) {
      emit(state.copyWith(false, true, false, e.toString()));
    }
  }

  void logout(BuildContext context) async {
    emit(state.copyWith(true, false, false, null));
    try {
      await sharedPrefs.removeToken();
      LogoutEvent().triggerLogout();
      emailController.clear();
      passwordController.clear();
      if (!context.mounted) return;
      emit(state.copyWith(false, false, false, null));
      Snackbar.successSnackbar(
        context,
        title: "Logout Successful",
        message: "You have been logged out successfully",
        icon: FontAwesomeIcons.rightFromBracket,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      emit(state.copyWith(false, true, false, e.toString()));

      if (!context.mounted) return;
      Snackbar.errorSnackbar(
        context,
        title: "Logout Failed",
        message: e.toString(),
      );
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                FontAwesomeIcons.rightFromBracket,
                color: Colors.red.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text('Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                logout(context); // Use the original context, not dialogContext
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await sharedPrefs.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Method to clear any auth errors
  void clearError() {
    if (state.hasError) {
      emit(state.copyWith(false, false, state.hasData, null));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
