import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _C();
}

class _C extends State<CustomersScreen> {
  List<Map<String, dynamic>> cs = [];
  @override
  void initState() { super.initState(); ld(); }
  Future<void> ld() async {
    final db = await DatabaseHelper.instance.database;
    try {
      final r = await db.query('customers');
      setState(() => cs = r);
    } catch (e) {
      await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)');
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              final db = await DatabaseHelper.instance.database;
              await db.insert('customers', {
                'name': 'Customer ${cs.length + 1}',
                'phone': '77700000${cs.length}'
              });
              ld();
            },
          )
        ],
      ),
      body: cs.isEmpty
          ? const Center(child: Text('No customers - Tap + to add'))
          : ListView.builder(
              itemCount: cs.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(child: Text(cs[i]['name'][0])),
                  title: Text(cs[i]['name']),
                  subtitle: Text(cs[i]['phone'] ?? ''),
                ),
              ),
            ),
    );
  }
}