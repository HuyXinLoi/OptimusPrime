import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Khi người dùng nhập email
class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

// Khi người dùng nhập mật khẩu
class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

// Khi nhấn nút đăng nhập
class LoginSubmitted extends LoginEvent {}
