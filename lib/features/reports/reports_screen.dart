
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class ReportsScreen extends StatefulWidget { const ReportsScreen({super.key}); @override State<ReportsScreen> createState()=>_R(); }
class _R extends State<ReportsScreen> {
  double total=0; int count=0;
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; final r=await db.query('invoices'); double t=0; for(var e in r){ t+= (e['total'] as num).toDouble(); } setState((){total=t; count=r.length;}); }
  @override Widget build(BuildContext c){
    return Padding(padding:const EdgeInsets.all(16), child: Column(children:[
      Card(child: Padding(padding:const EdgeInsets.all(20), child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text('عدد الفواتير'), Text('\$count', style: const TextStyle(fontWeight:FontWeight.bold, fontSize:20))]))),
      Card(child: Padding(padding:const EdgeInsets.all(20), child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text('اجمالي المبيعات'), Text('\$total ر.ي', style: const TextStyle(fontWeight:FontWeight.bold, fontSize:20, color:Colors.green))]))),
    ]));
  }
}
