import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/screen/login/bloc/login_bloc.dart';
import 'package:optimusprime/screen/login/bloc/login_event.dart';
import 'package:optimusprime/screen/login/bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers để quản lý focus
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Controller để quản lý scroll
  final _scrollController = ScrollController();

  // Key để xác định vị trí của form
  final _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Lắng nghe sự kiện focus để cuộn màn hình
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    // Giải phóng tài nguyên
    _emailFocusNode.removeListener(_handleFocusChange);
    _passwordFocusNode.removeListener(_handleFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Xử lý khi focus thay đổi
  void _handleFocusChange() {
    if (_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus) {
      // Đợi một chút để bàn phím hiện lên
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_formKey.currentContext != null) {
          // Tìm vị trí của form trong viewport
          final RenderObject? renderObject =
              _formKey.currentContext!.findRenderObject();
          if (renderObject != null) {
            // Cuộn đến vị trí của form với offset để đảm bảo form nằm trên bàn phím
            Scrollable.ensureVisible(
              _formKey.currentContext!,
              alignment:
                  0.2, // Đặt form ở vị trí 20% từ trên xuống của màn hình
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(router: GoRouter.of(context)),
      child: Scaffold(
        // Sử dụng resizeToAvoidBottomInset để màn hình tự động resize khi bàn phím xuất hiện
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade100,
                Colors.blue.shade50,
              ],
            ),
          ),
          child: SafeArea(
            // Sử dụng SingleChildScrollView với controller để có thể cuộn màn hình
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  // Thêm padding bottom để đảm bảo có đủ không gian khi bàn phím hiện lên
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Giảm khoảng cách phía trên khi bàn phím hiện lên
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom > 0
                          ? MediaQuery.of(context).size.height * 0.05
                          : MediaQuery.of(context).size.height * 0.12,
                    ),

                    // Logo với animation
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/img/motorbike_logo.png',
                          height: 100,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Welcome text với animation
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MotoMarket',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Login Form với key để xác định vị trí
                    Container(
                      key: _formKey,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email Input với FocusNode
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return TextFormField(
                                focusNode: _emailFocusNode,
                                onChanged: (email) => context
                                    .read<LoginBloc>()
                                    .add(EmailChanged(email)),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(
                                    Icons.email_rounded,
                                    color: Colors.blue.shade600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade600,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Colors.blue.shade50.withOpacity(0.3),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 16,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (_) {
                                  // Chuyển focus sang trường password khi nhấn next
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Password Input với FocusNode
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return TextFormField(
                                focusNode: _passwordFocusNode,
                                obscureText: true,
                                onChanged: (password) => context
                                    .read<LoginBloc>()
                                    .add(PasswordChanged(password)),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  prefixIcon: Icon(
                                    Icons.lock_rounded,
                                    color: Colors.blue.shade600,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade600,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor:
                                      Colors.blue.shade50.withOpacity(0.3),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 16,
                                ),
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  // Khi nhấn done, thực hiện đăng nhập
                                  if (!state.isLoading) {
                                    context
                                        .read<LoginBloc>()
                                        .add(LoginSubmitted());
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Error Message
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state.errorMessage != null) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade700,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          state.errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                          const SizedBox(height: 24),

                          // Login Button
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () => context
                                          .read<LoginBloc>()
                                          .add(LoginSubmitted()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        Colors.blue.shade300,
                                    elevation: 2,
                                    shadowColor: Colors.blue.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: state.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/signin');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
