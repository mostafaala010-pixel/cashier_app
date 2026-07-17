
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;
  DatabaseHelper._init();
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('cashier.db');
    return _db!;
  }
  Future<Database> _initDB(String fp) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fp);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future _createDB(Database db, int v) async {
    await db.execute('''CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, stockQuantity INTEGER, barcode TEXT)''');
    await db.execute('''CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT, total REAL, date TEXT)''');
    await db.execute('''CREATE TABLE invoice_items(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, productName TEXT, qty INTEGER, price REAL)''');
    await db.execute('''CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT)''');
  }
}
