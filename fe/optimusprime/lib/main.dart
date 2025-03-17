import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimusprime/base/route.dart';
import 'package:optimusprime/screen/products/bloc/product_bloc.dart';
import 'package:optimusprime/screen/shopping_cart/cart_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
