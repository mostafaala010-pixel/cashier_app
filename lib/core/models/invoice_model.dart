import 'product_model.dart';

class InvoiceItem {
  final Product product;
  final int quantity;
  final double totalPrice; // سعر المنتج * الكمية

  InvoiceItem({
    required this.product,
    required this.quantity,
  }) : totalPrice = product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'],
    );
  }
}

class Invoice {
  final String id;
  final DateTime dateTime;
  final List<InvoiceItem> items;
  final double totalAmount;
  final String paymentMethod; // كاش، بطاقة، إلخ
  final bool isSynced;        // مهم جداً للأوفلاين: هل تم رفعه للسحابة؟

  Invoice({
    required this.id,
    required this.dateTime,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    this.isSynced = false, // القيمة الافتراضية "غير متزامن"
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'items': items.map((x) => x.toMap()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'isSynced': isSynced ? 1 : 0, 
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      items: List<InvoiceItem>.from(map['items']?.map((x) => InvoiceItem.fromMap(x))),
      totalAmount: map['totalAmount'].toDouble(),
      paymentMethod: map['paymentMethod'],
      isSynced: map['isSynced'] == 1 || map['isSynced'] == true,
    );
  }
}