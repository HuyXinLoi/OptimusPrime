import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optimusprime/services/api_services.dart';
import 'package:optimusprime/services/auth_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../models/cart_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiService apiService;

  CartBloc({required this.apiService}) : super(CartState()) {
    on<LoadCart>(_onLoadCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<ProceedToCheckout>(_onProceedToCheckout);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      if (!isLoggedIn) {
        emit(state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Vui lòng đăng nhập để xem giỏ hàng',
        ));
        return;
      }

      final userId = await AuthService.getUserId(); // Lấy userId từ AuthService
      final cartData =
          await apiService.getCart(userId); // Truyền userId vào API
      emit(state.copyWith(
        status: CartStatus.success,
        cart: Cart.fromJson(cartData),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
      UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      await apiService.updateCartItemQuantity(
        event.productId,
        event.quantity,
      );
      add(LoadCart());
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      await apiService.removeFromCart(event.productId);
      add(LoadCart());
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      await apiService.clearCart();
      emit(CartState(status: CartStatus.success, cart: Cart.empty()));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onProceedToCheckout(
      ProceedToCheckout event, Emitter<CartState> emit) async {
    emit(state.copyWith(isCheckingOut: true));
    try {
      await apiService.checkout(
        event.address,
        event.phone,
        event.paymentMethod,
      );
      emit(state.copyWith(
        status: CartStatus.success,
        cart: Cart.empty(),
        isCheckingOut: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: e.toString(),
        isCheckingOut: false,
      ));
    }
  }
}
