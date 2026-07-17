import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _S();
}

class _S extends State<SalesScreen> {
  List<Map<String, dynamic>> pr = [];
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() { super.initState(); ld(); }

  Future<void> ld() async {
    final db = await DatabaseHelper.instance.database;
    var r = await db.query('products');
    if (r.isEmpty) {
      await db.insert('products', {'name': 'Pepsi', 'price': 300, 'stockQuantity': 100, 'barcode': '1'});
      await db.insert('products', {'name': 'Water', 'price': 100, 'stockQuantity': 200, 'barcode': '2'});
      r = await db.query('products');
    }
    setState(() => pr = r);
  }

  void addP(Map<String, dynamic> p) {
    setState(() {
      final i = cart.indexWhere((e) => e['id'] == p['id']);
      if (i >= 0) cart[i]['qty']++;
      else cart.add({...p, 'qty': 1});
    });
  }

  double get tot => cart.fold(0, (s, e) => s + (e['price'] as num) * (e['qty'] as int));

  Future<void> co() async {
    final db = await DatabaseHelper.instance.database;
    for (var it in cart) {
      await db.rawUpdate('UPDATE products SET stockQuantity=stockQuantity-? WHERE id=?', [it['qty'], it['id']]);
    }
    await db.insert('invoices', {'total': tot, 'date': DateTime.now().toIso8601String()});
    setState(() => cart = []);
    ld();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS Pro'), backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
      body: Row(children: [
        Expanded(
          flex: 2,
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.1, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: pr.length,
            itemBuilder: (_, i) {
              final p = pr[i];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => addP(p),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.shopping_bag, size: 32, color: Colors.blue),
                    Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${p['price']} YER'),
                    Text('Stock ${p['stockQuantity']}'),
                  ]),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(children: [
            Container(padding: const EdgeInsets.all(16), color: const Color(0xFF0F172A), child: Row(children: [const Text('Cart', style: TextStyle(color: Colors.white)), Text(' ${cart.length} items', style: const TextStyle(color: Colors.white70))])),
            Expanded(child: ListView.builder(itemCount: cart.length, itemBuilder: (_, i) => ListTile(title: Text(cart[i]['name']), subtitle: Text('x${cart[i]['qty']}'), trailing: Text('${(cart[i]['price'] as num) * (cart[i]['qty'] as int)}')))),
            Padding(padding: const EdgeInsets.all(16), child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)), onPressed: cart.isEmpty? null : co, child: Text('CHECKOUT $tot', style: const TextStyle(color: Colors.white))))),
          ]),
        ),
      ]),
    );
  }
}