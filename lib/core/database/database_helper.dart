
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;
  DatabaseHelper._init();
  Future<Database> get database async {
    if(_db!=null) return _db!;
    _db = await _initDB('cashier_pro.db');
    return _db!;
  }
  Future<Database> _initDB(String file) async {
    final path = join(await getDatabasesPath(), file);
    return await openDatabase(path, version: 3, onCreate: _create);
  }
  Future _create(Database db, int version) async {
    await db.execute('CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, stockQuantity INTEGER, barcode TEXT)');
    await db.execute('CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT, total REAL, date TEXT)');
    await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT)');
  }
}
