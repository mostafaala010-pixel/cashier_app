
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class CustomersScreen extends StatefulWidget { const CustomersScreen({super.key}); @override State<CustomersScreen> createState()=>_C(); }
class _C extends State<CustomersScreen> {
  List<Map<String,dynamic>> cs=[];
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; try{ final r=await db.query('customers'); setState(()=>cs=r); } catch(e){ await db.execute('CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)'); } }
  @override Widget build(BuildContext c){
    return Scaffold(
      appBar: AppBar(title: const Text('العملاء', style:TextStyle(fontWeight:FontWeight.bold)), backgroundColor:const Color(0xFF0F172A), foregroundColor:Colors.white, actions:[IconButton(icon:const Icon(Icons.person_add), onPressed:() async { final db=await DatabaseHelper.instance.database; await db.insert('customers',{'name':'عميل ${cs.length+1}','phone':'77700000${cs.length}'}); ld(); })]),
      body: cs.isEmpty? Center(child:Column(mainAxisAlignment:MainAxisAlignment.center, children:[Icon(Icons.people_outline, size:80, color:Colors.grey.withOpacity(0.3)), const SizedBox(height:16), const Text('لا يوجد عملاء بعد', style:TextStyle(fontSize:18)), const Text('اضغط + لإضافة عميل', style:TextStyle(color:Colors.grey))])) : ListView.builder(padding:const EdgeInsets.all(12), itemCount:cs.length, itemBuilder:(_,i)=> Card(child: ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFF0F172A), child:Text(cs[i]['name'][0], style:const TextStyle(color:Colors.white))), title:Text(cs[i]['name'], style:const TextStyle(fontWeight:FontWeight.bold)), subtitle:Text(cs[i]['phone']??''), trailing:const Icon(Icons.chevron_left)))),
      floatingActionButton: FloatingActionButton(onPressed:() async { final db=await DatabaseHelper.instance.database; await db.insert('customers',{'name':'عميل ${cs.length+1}','phone':'77700000${cs.length}'}); ld(); }, backgroundColor:const Color(0xFF0F172A), foregroundColor:Colors.white, child:const Icon(Icons.add)),
    );
  }
}
