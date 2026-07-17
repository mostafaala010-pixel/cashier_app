import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();
  Future<Database> get database async => _database ??= await _initDB('cashier.db');
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE products (id TEXT PRIMARY KEY, name TEXT, barcode TEXT, price REAL, cost REAL, stockQuantity INTEGER, minStockLimit INTEGER)');
    await db.execute('CREATE TABLE invoices (id INTEGER PRIMARY KEY AUTOINCREMENT, total REAL, paymentMethod TEXT, profit REAL, date TEXT)');
    await db.execute('CREATE TABLE invoice_items (id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, productId TEXT, quantity INTEGER, price REAL)');
  }
  Future<void> insertProduct(Product p) async {
    final db = await instance.database;
    await db.insert('products', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> decreaseStock(String id, int qty) async {
    final db = await instance.database;
    await db.rawUpdate('UPDATE products SET stockQuantity = stockQuantity - ? WHERE id = ?', [qty, id]);
  }
  Future<void> insertInvoice(List<CartItem> items, double total, String method, double profit) async {
    final db = await instance.database;
    final invoiceId = await db.insert('invoices', {'total': total, 'paymentMethod': method, 'profit': profit, 'date': DateTime.now().toIso8601String()});
    for (var item in items) {
      await db.insert('invoice_items', {'invoiceId': invoiceId, 'productId': item.product.id, 'quantity': item.quantity, 'price': item.product.price});
    }
  }
}