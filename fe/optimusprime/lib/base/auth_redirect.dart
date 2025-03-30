import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optimusprime/services/auth_service.dart';

// Widget bọc để kiểm tra xác thực trước khi hiển thị màn hình
class AuthRedirect extends StatefulWidget {
  final Widget child;
  final String redirectRoute;

  const AuthRedirect({
    Key? key,
    required this.child,
    required this.redirectRoute,
  }) : super(key: key);

  @override
  State<AuthRedirect> createState() => _AuthRedirectState();
}

class _AuthRedirectState extends State<AuthRedirect> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isLoggedIn = await AuthService.isLoggedIn();

    if (mounted) {
      setState(() {
        _isAuthenticated = isLoggedIn;
        _isLoading = false;
      });

      if (!isLoggedIn) {
        // Chuyển hướng đến trang đăng nhập nếu chưa đăng nhập
        Future.microtask(() {
          GoRouter.of(context).go(widget.redirectRoute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isAuthenticated) {
      return widget.child;
    } else {
      // Hiển thị màn hình trống trong khi chuyển hướng
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
