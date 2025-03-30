import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Nhập thông tin người dùng
class NameChanged extends SignInEvent {
  final String name;
  NameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class EmailChanged extends SignInEvent {
  final String email;
  EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignInEvent {
  final String password;
  PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends SignInEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object?> get props => [confirmPassword];
}

class GenderChanged extends SignInEvent {
  final String gender;
  GenderChanged(this.gender);
  @override
  List<Object?> get props => [gender];
}

// Sự kiện Submit đăng ký
class SignInSubmitted extends SignInEvent {
  final BuildContext context;
  SignInSubmitted(this.context);
  @override
  List<Object?> get props => [context];
}
