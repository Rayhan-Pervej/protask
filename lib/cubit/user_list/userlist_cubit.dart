import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protask/services/client_config.dart/api_handle.dart';

part 'userlist_state.dart';

class UserlistCubit extends Cubit<UserlistState> {
  final ApiHandle apiHandle;
  List<dynamic> filteredUsers = [];

  UserlistCubit(this.apiHandle) : super(UserlistLoading());

  Future<void> fetchUsers() async {
    try {
      final users = await apiHandle.getAllUsers();

      filteredUsers =
          users.map((user) {
            return {
              'id': user['id'],
              'photo': getFullPhotoUrl(user['photo_path']),
              'name': '${user['first_name']} ${user['last_name']}',
              'position': user['position'] ?? 'Not Assigned',
              'email': user['email'],
            };
          }).toList();
      print(filteredUsers);
      emit(UserlistLoaded(filteredUsers));
    } catch (e) {
      emit(UserlistError(e.toString()));
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(UserlistLoaded(filteredUsers));
    } else {
      final searchedUsers =
          filteredUsers
              .where(
                (user) =>
                    user['name'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      emit(UserlistLoaded(searchedUsers));
    }
  }

  String getFullPhotoUrl(String? photoPath) {
    const String baseUrl = "https://protask.shadhintech.com";

    if (photoPath != null && photoPath.isNotEmpty) {
      return photoPath.startsWith("http") ? photoPath : "$baseUrl$photoPath";
    } else {
      return "";
    }
  }
}
