import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protask/component/snackbar/snackbar.dart';
import 'package:protask/cubit/my_task_list/my_task_list_cubit.dart';
import 'package:protask/cubit/network/network_cubit.dart';
import 'package:protask/cubit/auth/auth_cubit.dart';
import 'package:protask/cubit/user_list/userlist_cubit.dart';
import 'package:protask/cubit/user_task_list/user_task_list_cubit.dart';
import 'package:protask/screens/login/login.dart';
import 'package:protask/screens/navbar.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';
import 'package:protask/services/client_config.dart/token_handle.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? token = await SharedPrefs().getToken();
  bool isTokenValid = token != null && token.isNotEmpty;
  runApp(
    MultiBlocProvider(

      
      providers: [
        BlocProvider<NetworkCubit>(create: (context) => NetworkCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider(
          create: (context) => UserlistCubit(ApiHandle())..fetchUsers(),
        ),
        BlocProvider<MyTaskListCubit>(
          create: (context) => MyTaskListCubit(ApiHandle())..fetchTasks(),
        ),
        BlocProvider<UserTaskListCubit>(
          create: (context) => UserTaskListCubit(ApiHandle()),
        ),
      ],
      child: MyApp(isTokenValid: isTokenValid),
    ),
  );

  // print("SharedPreferences Initialized: ${prefs.getKeys()}");

  // final ApiHandle apiHandle = ApiHandle();
  // final loginResponse = await apiHandle.logIn("rayhan.pervej@shadhinlab.com", "12345678");

  // if (loginResponse.containsKey("error")) {
  //   print("Login failed: ${loginResponse['error']}");
  // } else {
  //   print("Login successful!");

  //   // Fetch all users
  //   final users = await apiHandle.getAllUsers();
  //   print(users);

  //   // Fetch tasks for user 34
  //   final tasks = await apiHandle.getUserTasks(34);
  //   print(tasks);
  // }
}

class MyApp extends StatelessWidget {
  final bool isTokenValid;
  const MyApp({super.key, required this.isTokenValid});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Task',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      home: BlocListener<NetworkCubit, NetworkState>(
        listener: (context, state) {
          if (state is NetworkDisconnected) {
            Snackbar.warningSnackbar(
              context,
              title: "No Internet",
              message: "Please check your internet connection",
            );
          }
          // } else if (state is NetworkConnected) {
          //   Snackbar.successSnackbar(
          //     context,
          //     title: "Connected",
          //     message: "Enjoy our services",
          //     icon: FontAwesomeIcons.globe,
          //   );
          // }
        },
        child: isTokenValid ? Navbar() : Login(),
      ),
    );
  }
}
