
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class CustomersScreen extends StatefulWidget { const CustomersScreen({super.key}); @override State<CustomersScreen> createState()=>_Cu(); }
class _Cu extends State<CustomersScreen> {
  List<Map<String,dynamic>> cs=[];
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; final r=await db.query('customers'); setState(()=>cs=r); }
  @override Widget build(BuildContext c){
    if(cs.isEmpty){ return const Center(child:Text('لا يوجد عملاء بعد')); }
    return ListView.builder(itemCount:cs.length, itemBuilder:(_,i){ final it=cs[i]; return Card(child: ListTile(leading: const CircleAvatar(child:Icon(Icons.person)), title:Text(it['name'].toString()), subtitle:Text(it['phone'].toString()))); });
  }
}
