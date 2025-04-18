import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/login/models/user_model.dart';
import 'package:optimusprime/services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GoRouter router;

  LoginBloc({required this.router}) : super(const LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      if (state.email.isEmpty || state.password.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Sai tài khoản hoặc mật khẩu',
        ));
        return;
      }

      if (state.email.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Sai tài khoản hoặc mật khẩu',
        ));
        return;
      }

      if (state.password.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Sai tài khoản hoặc mật khẩu',
        ));
        return;
      }

      if (!isValidEmail(state.email)) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Sai tài khoản hoặc mật khẩu',
        ));
        return;
      }
      try {
        final response = await http.post(
          Uri.parse('https://optimusprime-o8pn.onrender.com/api/users/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': state.email,
            'password': state.password,
          }),
        );

        final responseData = jsonDecode(response.body);

        // if (response.statusCode == 200) {
        //   emit(state.copyWith(isLoading: false));

        //   // Điều hướng về màn hình home
        //   router.go('/');

        if (response.statusCode == 200) {
          // Create user object from response
          final user = User.fromJson(responseData);

          // Save user data to SharedPreferences
          await AuthService.saveUserData(user);

          emit(state.copyWith(isLoading: false));

          // Redirect to profile screen instead of home
          router.go('/profile');
        } else {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: responseData['message'] ?? 'Login failed',
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ));
      }
    });
  }
  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
