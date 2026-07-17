import 'product_model.dart';
class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, required this.quantity});
  double get totalPrice => product.price * quantity;
  double get totalProfit => (product.price - product.cost) * quantity;
}