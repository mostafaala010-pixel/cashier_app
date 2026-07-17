import 'package:flutter/material.dart';
import '../../core/db/db.dart';
import '../../core/theme/theme.dart';
class InvoicesScreen extends StatefulWidget { const InvoicesScreen({super.key}); @override State<InvoicesScreen> createState()=>_InvPro(); }
class _InvPro extends State<InvoicesScreen>{
  List<Map<String,dynamic>> inv=[];
  double total=0;
  @override void initState(){super.initState(); load();}
  Future<void> load() async { final db=await AppDB.db; final r=await db.query('invoices', orderBy:'id DESC'); double t=0; for(var e in r){ t+= (e['total'] as num).toDouble(); } setState((){inv=r; total=t;});}
  @override Widget build(BuildContext context){
    return Column(children:[
      Container(margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors:[ProTheme.primary, ProTheme.cardDark], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)), child: Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('اجمالي المبيعات', style: TextStyle(color: Colors.white60)), const SizedBox(height:6), Text('${total.toStringAsFixed(0)} ر.ي', style: const TextStyle(color: Colors.white, fontSize:28, fontWeight: FontWeight.w900)), const SizedBox(height:4), Text('${inv.length} فاتورة', style: const TextStyle(color: Colors.white60, fontSize:12))])), Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.receipt_long, color: ProTheme.green, size:32))]),
      Expanded(child: inv.isEmpty? const Center(child: Text('لا توجد فواتير بعد')): ListView.builder(padding: const EdgeInsets.symmetric(horizontal:12), itemCount: inv.length, itemBuilder: (_,i){
        final it=inv[i]; return Container(margin: const EdgeInsets.only(bottom:10), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14)), child: ListTile(leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: ProTheme.green.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.receipt, color: ProTheme.green)), title: Text('فاتورة #${it['id']} - ${it['total']} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(it['date'].toString().split('T').first, style: const TextStyle(fontSize:11)), trailing: const Icon(Icons.arrow_forward_ios, size:14), onTap: () async { final db=await AppDB.db; final items=await db.query('invoice_items', where:'invoiceId=?', whereArgs:[it['id']]); showModalBottomSheet(context: context, builder: (_)=> Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children:[Text('فاتورة #${it['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize:18)), const Divider(), ...items.map((e)=> ListTile(dense:true, title: Text(e['name'].toString()), subtitle: Text('الكمية: ${e['qty']}'), trailing: Text('${e['price']} ر.ي'))).toList(), const Divider(), Text('الاجمالي: ${it['total']} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold, fontSize:16))]))); }));
      }))
    ]);
  }
}
