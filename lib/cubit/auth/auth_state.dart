part of 'auth_cubit.dart';

class AuthState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool hasData;

  AuthState({
    required this.isLoading,
    required this.hasError,
    required this.hasData,
    this.errorMessage,
  });

  AuthState copyWith(isLoading, hasError, hasData, errorMessage){
    return AuthState(
      hasData: hasData,
      hasError: hasError,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
  }
}
