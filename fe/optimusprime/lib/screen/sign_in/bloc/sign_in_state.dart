import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String gender;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const SignInState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.gender = '',
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  SignInState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return SignInState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        confirmPassword,
        gender,
        isLoading,
        errorMessage,
        isSuccess
      ];
}
