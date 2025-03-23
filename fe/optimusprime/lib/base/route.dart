import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:optimusprime/screen/home/home_screen.dart';
import 'package:optimusprime/screen/login/login_screen.dart';
import 'package:optimusprime/screen/navigationbar/bottom_navigationbar_screen.dart';
import 'package:optimusprime/screen/product_detail/product_detail_screen.dart';
import 'package:optimusprime/screen/products/products_screen.dart';
import 'package:optimusprime/screen/profile/profile_screen.dart';
import 'package:optimusprime/screen/search/search_screen.dart';
import 'package:optimusprime/screen/shopping_cart/shopping_cart_screen.dart';
import 'package:optimusprime/screen/sign_in/sign_in_screen.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return BottomNavBar(
              child: child); // Important: Wrap everything with BottomNavBar
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(),
          ),
          GoRoute(
              path: '/product_detail/:id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ProductDetailScreen(
                  productId: id,
                );
              }),
          GoRoute(
            path: '/products',
            builder: (context, state) => ProductListScreen(),
          ),
          GoRoute(
            path: '/shoppingcart',
            builder: (context, state) => ShoppingCartScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => SearchScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: '/signin',
            builder: (context, state) => SignInScreen(),
          ),
        ],
      ),
    ],
  );
}
