abstract class CartEvent {}

class LoadCart extends CartEvent {}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;

  UpdateCartItemQuantity({
    required this.productId,
    required this.quantity,
  });
}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart({required this.productId});
}

class ClearCart extends CartEvent {}

class ProceedToCheckout extends CartEvent {
  final String address;
  final String phone;
  final String paymentMethod;

  ProceedToCheckout({
    required this.address,
    required this.phone,
    required this.paymentMethod,
  });
}
