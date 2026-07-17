
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class CashierScreen extends StatefulWidget { const CashierScreen({super.key}); @override State<CashierScreen> createState()=>_C(); }
class _C extends State<CashierScreen> {
  List<Map<String,dynamic>> products=[];
  List<Map<String,dynamic>> cart=[];
  @override void initState(){super.initState(); load();}
  Future<void> load() async { final db=await DatabaseHelper.instance.database; final r=await db.query('products'); setState(()=>products=r); }
  void addToCart(Map<String,dynamic> p){
    final i=cart.indexWhere((e)=>e['id']==p['id']);
    if(i>=0){ setState(()=>cart[i]['qty']++); } else { setState(()=>cart.add({'id':p['id'],'name':p['name'],'price':p['price'],'qty':1})); }
  }
  double get total => cart.fold(0,(s,e)=>s+(e['price']*e['qty']));
  Future<void> checkout() async {
    if(cart.isEmpty) return;
    final db=await DatabaseHelper.instance.database;
    final id=await db.insert('invoices', {'total':total,'date':DateTime.now().toIso8601String()});
    for(var it in cart){ await db.insert('invoice_items', {'invoiceId':id,'productName':it['name'],'qty':it['qty'],'price':it['price']}); }
    setState(()=>cart.clear());
    if(!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تمت عملية البيع بنجاح'))); 
  }
  @override Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness==Brightness.dark;
    return Column(children:[
      Expanded(flex:3, child: products.isEmpty? const Center(child:Text('لا توجد منتجات\nاضف من المخزون', textAlign:TextAlign.center)) : GridView.builder(padding:const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, childAspectRatio:1.1, crossAxisSpacing:12, mainAxisSpacing:12), itemCount:products.length, itemBuilder:(_,i){
        final p=products[i];
        return InkWell(onTap:()=>addToCart(p), borderRadius:BorderRadius.circular(16), child: Container(decoration:BoxDecoration(color:isDark? Colors.white.withOpacity(0.05): Colors.white, borderRadius:BorderRadius.circular(16), border:Border.all(color:isDark? Colors.white10: Colors.black12)), padding:const EdgeInsets.all(12), child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[Container(padding:const EdgeInsets.all(10), decoration:BoxDecoration(color:Colors.blue.withOpacity(0.1), shape:BoxShape.circle), child: const Icon(Icons.shopping_bag, color:Colors.blue)), const SizedBox(height:8), Text(p['name'].toString(), style: const TextStyle(fontWeight:FontWeight.bold), textAlign:TextAlign.center), const SizedBox(height:4), Container(padding:const EdgeInsets.symmetric(horizontal:8, vertical:2), decoration:BoxDecoration(color:Colors.green.withOpacity(0.1), borderRadius:BorderRadius.circular(6)), child: Text('${p['price']} ر.ي', style: const TextStyle(color:Color(0xFF16A34A), fontWeight:FontWeight.bold)))])));
      })),
      Container(decoration:BoxDecoration(color:isDark? const Color(0xFF1E293B): Colors.white, borderRadius: const BorderRadius.vertical(top:Radius.circular(20)), boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.1), blurRadius:10)]), padding:const EdgeInsets.all(16), child: Column(children:[
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[Text('السلة (${cart.length})', style: const TextStyle(fontWeight:FontWeight.bold, fontSize:16)), TextButton(onPressed:()=>setState(()=>cart.clear()), child: const Text('افراغ'))]),
        const SizedBox(height:8),
        ...cart.map((e)=> ListTile(dense:true, title:Text(e['name']), subtitle:Text('الكمية: ${e['qty']}'), trailing:Text('${(e['price']*e['qty'])} ر.ي'))).toList(),
        const Divider(),
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children:[const Text('الاجمالي', style:TextStyle(fontWeight:FontWeight.bold, fontSize:18)), Text('$total ر.ي', style: const TextStyle(fontWeight:FontWeight.bold, fontSize:20, color:Colors.green))]),
        const SizedBox(height:12),
        SizedBox(width:double.infinity, height:50, child: ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:const Color(0xFF16A34A), shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12))), onPressed:checkout, child: const Text('دفع واتمام البيع', style:TextStyle(color:Colors.white, fontWeight:FontWeight.bold, fontSize:16))))
      ]))
    ]);
  }
}
