class Product {
  final String id;
  final String name;
  final String barcode;
  final double price;
  final double cost;
  final int stockQuantity;
  final int minStockLimit;
  Product({required this.id, required this.name, required this.barcode, required this.price, required this.cost, required this.stockQuantity, required this.minStockLimit});
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'barcode': barcode, 'price': price, 'cost': cost, 'stockQuantity': stockQuantity, 'minStockLimit': minStockLimit};
  factory Product.fromMap(Map<String, dynamic> map) => Product(id: map['id'].toString(), name: map['name'], barcode: map['barcode'], price: (map['price'] as num).toDouble(), cost: (map['cost'] as num).toDouble(), stockQuantity: map['stockQuantity'] as int, minStockLimit: map['minStockLimit'] as int);
}