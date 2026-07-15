import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/invoice_model.dart';

class DatabaseHelper {
  // تصميم الكلاس بنمط Singleton لضمان وجود نسخة واحدة فقط من قاعدة البيانات في التطبيق
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cashier.db');
    return _database!;
  }

  // تهيئة وتحديد مسار حفظ قاعدة البيانات في جهاز المستخدم
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // بناء الجداول البرمجية داخل الجهاز لأول مرة
  Future _createDB(Database db, int version) async {
    // 1. جدول المنتجات والمخزن
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        barcode TEXT NOT NULL,
        price REAL NOT NULL,
        cost REAL NOT NULL,
        stockQuantity INTEGER NOT NULL,
        minStockLimit INTEGER NOT NULL
      )
    ''');

    // 2. جدول الفواتير
    await db.execute('''
      CREATE TABLE invoices (
        id TEXT PRIMARY KEY,
        dateTime TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        isSynced INTEGER NOT NULL
      )
    ''');

    // 3. جدول عناصر الفاتورة (الربط المباشر بين المنتجات المبيوعة والفاتورة الكبيرة)
    await db.execute('''
      CREATE TABLE invoice_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceId TEXT NOT NULL,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        totalPrice REAL NOT NULL,
        FOREIGN KEY (invoiceId) REFERENCES invoices (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- 📝 عمليات إدارة المنتجات (CRUD Operations) ---

  // إضافة أو تحديث منتج
  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert(
      'products', 
      product.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace, // إذا كان موجوداً مسبقاً، استبدله بالجديد
    );
  }

  // جلب جميع المنتجات لعرضها في شاشة المخزن
  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((json) => Product.fromMap(json)).toList();
  }

  // البحث عن منتج بواسطة الباركود (مهم جداً للبيع السريع عبر الكاميرا)
  Future<Product?> getProductByBarcode(String barcode) async {
    final db = await instance.database;
    final maps = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null; // إذا لم يجد المنتج
  }

  // --- 🧾 عمليات إدارة الفواتير والبيع الذكي ---

  // حفظ الفاتورة وخصم الكمية المبيوعة من المخزن فوراً في عملية واحدة آمنة
  Future<void> insertInvoice(Invoice invoice) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      // 1. حفظ الفاتورة الأساسية
      await txn.insert('invoices', {
        'id': invoice.id,
        'dateTime': invoice.dateTime.toIso8601String(),
        'totalAmount': invoice.totalAmount,
        'paymentMethod': invoice.paymentMethod,
        'isSynced': invoice.isSynced ? 1 : 0,
      });

      // 2. حفظ العناصر المبيوعة وتعديل كمياتها في المخزن
      for (var item in invoice.items) {
        await txn.insert('invoice_items', {
          'invoiceId': invoice.id,
          'productId': item.product.id,
          'quantity': item.quantity,
          'totalPrice': item.totalPrice,
        });

        // 3. خصم الكمية من جدول المنتجات ليبقى المخزن محدثاً بدقة
        await txn.rawUpdate('''
          UPDATE products 
          SET stockQuantity = stockQuantity - ? 
          WHERE id = ?
        ''', [item.quantity, item.product.id]);
      }
    });
  }

  // جلب سجل الفواتير لعرضه في شاشة التقارير والمبيعات
  Future<List<Invoice>> getAllInvoices() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> invoiceMaps = await db.query('invoices', orderBy: 'dateTime DESC');

    List<Invoice> invoices = [];

    for (var map in invoiceMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [map['id']],
      );

      List<InvoiceItem> items = [];
      for (var itemMap in itemMaps) {
        final List<Map<String, dynamic>> productMaps = await db.query(
          'products',
          where: 'id = ?',
          whereArgs: [itemMap['productId']],
        );

        if (productMaps.isNotEmpty) {
          final product = Product.fromMap(productMaps.first);
          items.add(InvoiceItem(
            product: product,
            quantity: itemMap['quantity'],
          ));
        }
      }

      invoices.add(Invoice(
        id: map['id'],
        dateTime: DateTime.parse(map['dateTime']),
        items: items,
        totalAmount: map['totalAmount'],
        paymentMethod: map['paymentMethod'],
        isSynced: map['isSynced'] == 1,
      ));
    }

    return invoices;
  }

  // إغلاق قاعدة البيانات بأمان
  Future close() async {
    final db = await _database;
    if (db != null) await db.close();
  }
}