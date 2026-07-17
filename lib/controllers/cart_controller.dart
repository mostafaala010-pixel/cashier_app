import 'package:flutter/material.dart';
import '../core/models/product_model.dart';
import '../core/models/cart_item_model.dart';
import '../core/database/database_helper.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;
  double get totalAmount => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get totalProfit => _cartItems.fold(0, (sum, item) => sum + item.totalProfit);

  void addProductToCart(Product product) {
    final index = _cartItems.indexWhere((e) => e.product.id == product.id);
    if (index!= -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeOrDecreaseProduct(Product product) {
    final index = _cartItems.indexWhere((e) => e.product.id == product.id);
    if (index!= -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems = [];
    notifyListeners();
  }

  Future<bool> checkout(String paymentMethod) async {
    if (_cartItems.isEmpty) return false;
    try {
      await DatabaseHelper.instance.insertInvoice(_cartItems, totalAmount, paymentMethod, totalProfit);
      for (var item in _cartItems) {
        await DatabaseHelper.instance.decreaseStock(item.product.id, item.quantity);
      }
      clearCart();
      return true;
    } catch (e) {
      return false;
    }
  }
}