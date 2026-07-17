import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class AppDB {
  static Database? _db;
  static Future<Database> get db async {
    if(_db!=null) return _db!;
    final path = join(await getDatabasesPath(), 'pro_pos.db');
    _db = await openDatabase(path, version: 2, onCreate: (db,v) async {
      await db.execute('CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, price REAL, qty INTEGER, barcode TEXT, image TEXT)');
      await db.execute('CREATE TABLE invoices(id INTEGER PRIMARY KEY AUTOINCREMENT, total REAL, date TEXT, customer TEXT)');
      await db.execute('CREATE TABLE invoice_items(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, name TEXT, qty INTEGER, price REAL)');
      // seed
      await db.insert('products', {'name':'بيبسي 250مل','price':150,'qty':50,'barcode':'123456','image':''});
      await db.insert('products', {'name':'ماء صحة 500مل','price':100,'qty':120,'barcode':'123457','image':''});
      await db.insert('products', {'name':'شيبس ليز','price':300,'qty':30,'barcode':'123458','image':''});
    }, onUpgrade: (db,ov,nv) async {
      try{ await db.execute('ALTER TABLE products ADD COLUMN barcode TEXT'); }catch(_){}
    });
    return _db!;
  }
}
