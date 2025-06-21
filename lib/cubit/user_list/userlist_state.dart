part of 'userlist_cubit.dart';

abstract class UserlistState {}

class UserlistLoading extends UserlistState {}

class UserlistLoaded extends UserlistState {
  final List<dynamic> users;

  UserlistLoaded(this.users);

  
}

class UserlistError extends UserlistState {
  final String message;

  UserlistError(this.message);


}
