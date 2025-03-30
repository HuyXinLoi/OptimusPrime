import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
  });

  // Copy state để cập nhật dữ liệu mới
  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, isLoading, errorMessage];
}
