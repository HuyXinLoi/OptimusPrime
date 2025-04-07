import '../models/cart_model.dart';

enum CartStatus { initial, loading, success, failure }

class CartState {
  final CartStatus status;
  final Cart cart;
  final String? errorMessage;
  final bool isCheckingOut;

  CartState({
    this.status = CartStatus.initial,
    Cart? cart,
    this.errorMessage,
    this.isCheckingOut = false,
  }) : cart = cart ?? Cart.empty();

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? errorMessage,
    bool? isCheckingOut,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
    );
  }
}
