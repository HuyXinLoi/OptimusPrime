import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_model.dart';
import '../../repositories/cart_repository.dart';

// Events
abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final String productId;
  final int quantity;

  AddToCart({required this.productId, required this.quantity});
}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart({required this.productId});
}

class CheckoutCart extends CartEvent {
  final String address;
  final String phone;
  final String paymentMethod;

  CheckoutCart({
    required this.address,
    required this.phone,
    required this.paymentMethod,
  });
}

// States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;

  CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<CheckoutCart>(_onCheckoutCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final cart = await cartRepository.getCart();
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final cart =
          await cartRepository.addToCart(event.productId, event.quantity);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final cart = await cartRepository.removeFromCart(event.productId);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onCheckoutCart(
      CheckoutCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      await cartRepository.checkout(
          event.address, event.phone, event.paymentMethod);
      emit(CartInitial());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
