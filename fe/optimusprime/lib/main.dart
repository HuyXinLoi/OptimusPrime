import 'package:flutter/material.dart';
import 'package:optimusprime/base/route.dart';
import 'package:optimusprime/screen/home/home_screen.dart';


void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});

  final _router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}