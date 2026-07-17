
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class InvoicesScreen extends StatefulWidget { const InvoicesScreen({super.key}); @override State<InvoicesScreen> createState()=>_I(); }
class _I extends State<InvoicesScreen> {
  List<Map<String,dynamic>> inv=[]; 
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; final r=await db.query('invoices', orderBy:'id DESC'); setState(()=>inv=r); }
  @override Widget build(BuildContext c){
    final total = inv.fold<double>(0,(s,e)=>s+(e['total'] as num).toDouble());
    return Scaffold(
      appBar: AppBar(title: const Text('الفواتير والمبيعات', style:TextStyle(fontWeight:FontWeight.bold)), backgroundColor:const Color(0xFF0F172A), foregroundColor:Colors.white),
      body: inv.isEmpty? const Center(child:Text('لا توجد فواتير بعد
ابدأ البيع من الكاشير', textAlign:TextAlign.center)) : Column(children:[
        Container(margin:const EdgeInsets.all(16), padding:const EdgeInsets.all(20), decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF0F172A), Color(0xFF1E293B)]), borderRadius:BorderRadius.circular(16)), child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Column(crossAxisAlignment:CrossAxisAlignment.start, children:[const Text('إجمالي المبيعات', style:TextStyle(color:Colors.white70)), Text('$total ر.ي', style:const TextStyle(color:Colors.white, fontSize:28, fontWeight:FontWeight.bold))]), Container(padding:const EdgeInsets.all(12), decoration:BoxDecoration(color:Colors.white.withOpacity(0.1), shape:BoxShape.circle), child:const Icon(Icons.payments, color:Colors.green, size:32))])),
        Expanded(child: ListView.builder(padding:const EdgeInsets.all(12), itemCount:inv.length, itemBuilder:(_,i){ final it=inv[i]; return Card(child: ListTile(leading:Container(padding:const EdgeInsets.all(8), decoration:BoxDecoration(color:Colors.blue.withOpacity(0.1), borderRadius:BorderRadius.circular(8)), child:const Icon(Icons.receipt, color:Colors.blue)), title:Text('فاتورة #${it['id']} - ${it['total']} ر.ي', style:const TextStyle(fontWeight:FontWeight.bold)), subtitle:Text(it['date'].toString().split('T').first), trailing:const Icon(Icons.chevron_left))); }))
      ]),
    );
  }
}
