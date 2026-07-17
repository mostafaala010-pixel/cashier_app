import 'package:flutter/material.dart';
import '../../core/db/db.dart';
import '../../core/theme/theme.dart';

class CashierScreen extends StatefulWidget { const CashierScreen({super.key}); @override State<CashierScreen> createState()=>_CashierPro(); }
class _CashierPro extends State<CashierScreen>{
  List<Map<String,dynamic>> products=[];
  List<Map<String,dynamic>> filtered=[];
  List<Map<String,dynamic>> cart=[];
  TextEditingController search = TextEditingController();
  @override void initState(){super.initState(); load(); search.addListener((){ filter(search.text); });}
  Future<void> load() async { final db=await AppDB.db; final r=await db.query('products', orderBy: 'id DESC'); setState((){products=r; filtered=r;});}
  void filter(String q){ if(q.isEmpty){setState(()=>filtered=products);} else { setState(()=>filtered=products.where((e)=> e['name'].toString().contains(q) || e['barcode'].toString().contains(q)).toList()); } }
  void addToCart(Map<String,dynamic> p){
    final idx=cart.indexWhere((e)=>e['id']==p['id']);
    if(idx>=0){ setState(()=>cart[idx]['cQty']++);} else { setState(()=>cart.add({...p, 'cQty':1}));}
  }
  double get total { double t=0; for(var e in cart){ t+= (e['price'] as num).toDouble() * (e['cQty'] as int); } return t; }
  Future<void> pay() async {
    if(cart.isEmpty) return;
    final db=await AppDB.db;
    final invId=await db.insert('invoices', {'total':total, 'date':DateTime.now().toIso8601String(), 'customer':'عميل نقدي'});
    for(var c in cart){ await db.insert('invoice_items', {'invoiceId':invId, 'name':c['name'], 'qty':c['cQty'], 'price':c['price']}); final newQty = (c['qty'] as int) - (c['cQty'] as int); await db.update('products', {'qty': newQty<0?0:newQty}, where:'id=?', whereArgs:[c['id']]); }
    setState(()=>cart.clear()); load();
    if(!mounted) return; ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم البيع بنجاح - تم خصم الكمية من المخزون'), backgroundColor: ProTheme.green));
  }
  @override Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return Column(children:[
      Container(color: isDark? ProTheme.primary: Colors.white, padding: const EdgeInsets.fromLTRB(16,12,16,12), child: Column(children:[
        TextField(controller: search, decoration: InputDecoration(hintText:'بحث بالاسم او امسح الباركود...', prefixIcon: const Icon(Icons.search), suffixIcon: IconButton(icon: const Icon(Icons.qr_code_scanner, color: ProTheme.green), onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة الباركود جاهزة - اربطها بـ mobile_scanner'))); }), filled: true, fillColor: isDark? ProTheme.cardDark: const Color(0xFFF1F5F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal:12, vertical:0))),
        const SizedBox(height:12),
        Row(children:[
          _statChip('المنتجات', '${filtered.length}', Colors.blue),
          const SizedBox(width:8),
          _statChip('السلة', '${cart.length}', ProTheme.green),
          const Spacer(),
          Text('${total.toStringAsFixed(0)} ر.ي', style: const TextStyle(fontSize:18, fontWeight: FontWeight.w900, color: ProTheme.green))
        ])
      ])),
      Expanded(child: filtered.isEmpty? const Center(child: Text('لا يوجد منتجات')): GridView.builder(padding: const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing:12, mainAxisSpacing:12), itemCount: filtered.length, itemBuilder: (_,i){
        final p=filtered[i]; final int q = (p['qty'] as int?)??0; final bool low = q<=5;
        return InkWell(onTap: ()=> addToCart(p), borderRadius: BorderRadius.circular(18), child: Container(decoration: BoxDecoration(color: isDark? ProTheme.cardDark: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: low? Colors.red.withOpacity(0.3): Colors.transparent), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius:10, offset: const Offset(0,4))]), child: Column(children:[
          Expanded(child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(color: low? Colors.red.withOpacity(0.1): ProTheme.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Icon(low? Icons.warning_amber: Icons.inventory_2, size: 38, color: low? Colors.red: ProTheme.green)))),
          Padding(padding: const EdgeInsets.fromLTRB(10,0,10,10), child: Column(children:[
            Text(p['name'].toString(), maxLines:1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize:13)),
            const SizedBox(height:2),
            Text('باركود: ${p['barcode']}', style: const TextStyle(fontSize:10, color: Colors.grey)),
            const SizedBox(height:6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[
              Container(padding: const EdgeInsets.symmetric(horizontal:8, vertical:3), decoration: BoxDecoration(color: ProTheme.green.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text('${p['price']} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold, fontSize:12, color: ProTheme.green))),
              Text('x$q', style: TextStyle(fontSize:11, color: low? Colors.red: Colors.grey, fontWeight: low? FontWeight.bold: FontWeight.normal))
            ])
          ]))
        ]))));
      })),
      if(cart.isNotEmpty) Container(decoration: BoxDecoration(color: isDark? ProTheme.cardDark: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius:20)]), padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children:[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Text('السلة (${cart.length})', style: const TextStyle(fontWeight: FontWeight.bold)), TextButton(onPressed: ()=> setState(()=>cart.clear()), child: const Text('افراغ', style: TextStyle(color: Colors.red)))]),
        SizedBox(height: 80, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: cart.length, itemBuilder: (_,i){ final c=cart[i]; return Container(margin: const EdgeInsets.only(right:8), padding: const EdgeInsets.symmetric(horizontal:12, vertical:8), decoration: BoxDecoration(color: isDark? ProTheme.primary: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Text(c['name'].toString(), style: const TextStyle(fontSize:11, fontWeight: FontWeight.bold)), const SizedBox(height:4), Row(children:[IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: (){ if(c['cQty']>1){ setState(()=>cart[i]['cQty']--);} else { setState(()=>cart.removeAt(i)); } }, icon: const Icon(Icons.remove_circle, size:18, color: Colors.red)), Text('${c['cQty']}', style: const TextStyle(fontWeight: FontWeight.bold)), IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: ()=> setState(()=>cart[i]['cQty']++), icon: const Icon(Icons.add_circle, size:18, color: ProTheme.green))])])); })),
        const SizedBox(height:12),
        SizedBox(width: double.infinity, height:54, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: ProTheme.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: pay, icon: const Icon(Icons.payments, color: Colors.white), label: Text('دفع ${total.toStringAsFixed(0)} ر.ي', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize:16))))
      ]))
    ]);
  }
  Widget _statChip(String t, String v, Color c){ return Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: c.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Row(children:[Text(t, style: TextStyle(color:c, fontSize:11)), const SizedBox(width:6), Text(v, style: TextStyle(color:c, fontWeight: FontWeight.bold))])) ; }
}
