class Product {
  final String id;
  final String name;          // اسم المنتج
  final String barcode;       // الكود المقروء بالكاميرا
  final double price;         // سعر البيع
  final double cost;          // سعر التكلفة (لحساب الأرباح بدقة)
  final int stockQuantity;    // الكمية الحالية في المخزن
  final int minStockLimit;    // التنبيه عند اقتراب النفاد

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.cost,
    required this.stockQuantity,
    required this.minStockLimit,
  });

  // للتأكد من حالة المخزن وإطلاق التنبيهات الذكية
  bool get isStockLow => stockQuantity <= minStockLimit;

  // تحويل الكائن إلى Map لحفظه في قاعدة البيانات المحلية أو السحابية
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'price': price,
      'cost': cost,
      'stockQuantity': stockQuantity,
      'minStockLimit': minStockLimit,
    };
  }

  // إنشاء الكائن عند القراءة من قاعدة البيانات
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      barcode: map['barcode'],
      price: map['price'].toDouble(),
      cost: map['cost'].toDouble(),
      stockQuantity: map['stockQuantity'],
      minStockLimit: map['minStockLimit'],
    );
  }
}