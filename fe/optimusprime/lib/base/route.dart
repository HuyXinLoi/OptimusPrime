import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:optimusprime/screen/home/home_screen.dart';
import 'package:optimusprime/screen/navigationbar/bottom_navigationbar_screen.dart';
import 'package:optimusprime/screen/product_detail/product_detail_screen.dart';
import 'package:optimusprime/screen/products/product_model.dart';

import 'package:optimusprime/screen/products/products_screen.dart';
import 'package:optimusprime/screen/profile/profile_screen.dart';
import 'package:optimusprime/screen/search/search_screen.dart';
import 'package:optimusprime/screen/shopping_cart/shopping_cart_screen.dart';

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
            path: '/product-detail',
            builder: (context, state) {
              final product = state.extra as Product;
              return ProductDetailScreen(product: product);
            },
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => ProductsScreen(),
          ),
          GoRoute(
            path: '/shoppingcart',
            builder: (context, state) => ShoppingCartScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => SearchScreen(),
          ),
        ],
      ),
    ],
  );
}
