import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/sign_in/bloc/sign_in_bloc.dart';
import 'package:optimusprime/screen/sign_in/bloc/sign_in_event.dart';
import 'package:optimusprime/screen/sign_in/bloc/sign_in_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sign Up Success! Redirecting to Login..."),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              context.go('/login');
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.blue.shade50,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 20),

                  // Name Input
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return TextField(
                        onChanged: (name) =>
                            context.read<SignInBloc>().add(NameChanged(name)),
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Email Input
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return TextField(
                        onChanged: (email) =>
                            context.read<SignInBloc>().add(EmailChanged(email)),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Password Input
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return TextField(
                        obscureText: true,
                        onChanged: (password) => context
                            .read<SignInBloc>()
                            .add(PasswordChanged(password)),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Confirm Password Input
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return TextField(
                        obscureText: true,
                        onChanged: (confirmPassword) => context
                            .read<SignInBloc>()
                            .add(ConfirmPasswordChanged(confirmPassword)),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // Gender Selection
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        value: state.gender.isNotEmpty ? state.gender : null,
                        items: ['male', 'female', 'other']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (gender) => context
                            .read<SignInBloc>()
                            .add(GenderChanged(gender!)),
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sign Up Button
                  BlocBuilder<SignInBloc, SignInState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context
                                  .read<SignInBloc>()
                                  .add(SignInSubmitted(context)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
