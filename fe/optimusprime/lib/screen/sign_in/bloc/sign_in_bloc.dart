import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<GenderChanged>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });

    on<SignInSubmitted>((event, emit) async {
      if (state.name.isEmpty ||
          state.email.isEmpty ||
          state.password.isEmpty ||
          state.confirmPassword.isEmpty ||
          state.gender.isEmpty) {
        emit(state.copyWith(errorMessage: "Vui lòng nhập đầy đủ thông tin"));
        return;
      }

      if (state.password != state.confirmPassword) {
        emit(state.copyWith(errorMessage: "Mật khẩu không khớp"));
        return;
      }

      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        final url = Uri.parse("http://10.0.2.2:9000/api/users/register");
        final headers = {"Content-Type": "application/json"};
        final body = jsonEncode({
          "name": state.name,
          "email": state.email,
          "password": state.password,
          "confirmPassword": state.confirmPassword,
          "gender": state.gender,
        });

        final response = await http.post(url, headers: headers, body: body);
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
          event.context.go('/login');
        } else {
          emit(state.copyWith(
              isLoading: false,
              errorMessage: responseData["message"] ?? "Đăng ký thất bại"));
        }
      } catch (e) {
        print(e);
        emit(state.copyWith(
            isLoading: false, errorMessage: "Lỗi kết nối server"));
      }
    });
  }
}
