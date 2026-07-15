import 'package:flutter/material.dart';
import '../core/models/product_model.dart';
import '../core/models/invoice_model.dart';
import '../core/database/database_helper.dart';

class CartController extends ChangeNotifier {
  // قائمة العناصر الموجودة داخل سلة الشراء الحالية
  final List<InvoiceItem> _cartItems = [];

  // السماح لقراءة عناصر السلة من الواجهات بدون التعديل عليها مباشرة
  List<InvoiceItem> get cartItems => _cartItems;

  // حساب الإجمالي المالي الكلي للسلة تلقائياً وبسرعة
  double get totalAmount => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // 1. إضافة منتج للسلة (عند قراءة الباركود أو الاختيار اليدوي)
  void addProductToCart(Product product) {
    // التحقق إذا كان المنتج موجوداً مسبقاً في السلة لزيادة الكمية فقط
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      int currentQty = _cartItems[index].quantity;
      _cartItems[index] = InvoiceItem(product: product, quantity: currentQty + 1);
    } else {
      // إذا كان منتجاً جديداً، نضيفه لأول مرة بكمية 1
      _cartItems.add(InvoiceItem(product: product, quantity: 1));
    }
    
    notifyListeners(); // أمر برمجى يقوم بتحديث شاشة الكاشير فوراً أمام العميل
  }

  // 2. تقليل كمية منتج أو حذفه تماماً إذا أصبحت الكمية صفر
  void removeOrDecreaseProduct(Product product) {
    int index = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index] = InvoiceItem(product: product, quantity: _cartItems[index].quantity - 1);
      } else {
        _cartItems.removeAt(index); // حذفه نهائياً من السلة
      }
      notifyListeners();
    }
  }

  // 3. تفريغ السلة بالكامل (في حال إلغاء الفاتورة)
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // 4. إتمام عملية البيع (الـ Checkout) وحفظها في قاعدة البيانات المحلية
  Future<bool> checkout(String paymentMethod) async {
    if (_cartItems.isEmpty) return false;

    try {
      // إنشاء كائن الفاتورة النهائي بالاعتماد على محتويات السلة
      final invoice = Invoice(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // رقم فريد للفاتورة يعتمد على وقت اللحظة الحالية
        dateTime: DateTime.now(),
        items: List.from(_cartItems),
        totalAmount: totalAmount,
        paymentMethod: paymentMethod,
        isSynced: false, // لم ترفع للسحابة بعد (أوفلاين)
      );

      // استدعاء محرك قاعدة البيانات لحفظ الفاتورة وتحديث المخزن فوراً
      await DatabaseHelper.instance.insertInvoice(invoice);

      // مسح السلة لتجهيز الكاشير للزبون التالي
      clearCart();
      return true;
    } catch (e) {
      print("خطأ أثناء إتمام عملية البيع: $e");
      return false;
    }
  }
}