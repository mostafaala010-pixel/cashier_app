
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class SalesScreen extends StatefulWidget { const SalesScreen({super.key}); @override State<SalesScreen> createState()=>_S(); }
class _S extends State<SalesScreen> {
  List<Map<String,dynamic>> pr=[];
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; final r=await db.query('products'); setState(()=>pr=r); }
  @override Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness==Brightness.dark;
    if(pr.isEmpty){ return const Center(child:Text('لا توجد منتجات في المخزون')); }
    return GridView.builder(padding:const EdgeInsets.all(12), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2, childAspectRatio:0.9, crossAxisSpacing:12, mainAxisSpacing:12), itemCount:pr.length, itemBuilder:(_,i){
      final p=pr[i];
      final int qty = (p['stockQuantity'] as int?) ?? 0;
      final bool low = qty < 10;
      return Container(decoration:BoxDecoration(color:isDark? const Color(0xFF1E293B): Colors.white, borderRadius:BorderRadius.circular(16), border: low? Border.all(color:Colors.red.withOpacity(0.5)): null, boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.05), blurRadius:8)]), child: InkWell(onTap:(){}, borderRadius:BorderRadius.circular(16), child: Padding(padding:const EdgeInsets.all(12), child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[
        Container(padding:const EdgeInsets.all(14), decoration:BoxDecoration(color: low? Colors.red.withOpacity(0.1): Colors.blue.withOpacity(0.1), shape:BoxShape.circle), child: Icon(low? Icons.warning: Icons.shopping_bag, color: low? Colors.red: Colors.blue, size:28)),
        const SizedBox(height:10),
        Text(p['name'].toString(), textAlign:TextAlign.center, style: const TextStyle(fontWeight:FontWeight.bold, fontSize:14)),
        const SizedBox(height:4),
        Container(padding:const EdgeInsets.symmetric(horizontal:8, vertical:2), decoration:BoxDecoration(color:Colors.green.withOpacity(0.1), borderRadius:BorderRadius.circular(6)), child: Text('${p['price']} ر.ي', style: const TextStyle(color:Color(0xFF16A34A), fontWeight:FontWeight.bold, fontSize:13))),
        const SizedBox(height:4),
        Text('الكمية: $qty', style: TextStyle(color: low? Colors.red: Colors.grey, fontSize:11))
      ]))));
    });
  }
}
