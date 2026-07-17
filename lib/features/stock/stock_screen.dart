
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class StockScreen extends StatefulWidget { const StockScreen({super.key}); @override State<StockScreen> createState()=>_St(); }
class _St extends State<StockScreen> {
  List<Map<String,dynamic>> pr=[]; String q='';
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; final r=await db.query('products', orderBy:'stockQuantity ASC'); setState(()=>pr=r); }
  List<Map<String,dynamic>> get filtered => pr.where((e)=> e['name'].toString().contains(q)).toList();
  Future<void> addDialog() async {
    final nameC=TextEditingController(); final priceC=TextEditingController(); final qtyC=TextEditingController();
    await showDialog(context:context, builder:(_)=> AlertDialog(title: const Text('إضافة منتج جديد', textAlign:TextAlign.right), content: Column(mainAxisSize:MainAxisSize.min, children:[TextField(controller:nameC, decoration:const InputDecoration(labelText:'اسم المنتج'), textAlign:TextAlign.right), TextField(controller:priceC, decoration:const InputDecoration(labelText:'السعر'), keyboardType:TextInputType.number), TextField(controller:qtyC, decoration:const InputDecoration(labelText:'الكمية'), keyboardType:TextInputType.number)]), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:const Text('إلغاء')), ElevatedButton(onPressed:() async { final db=await DatabaseHelper.instance.database; await db.insert('products',{'name':nameC.text, 'price':double.tryParse(priceC.text)??0, 'stockQuantity':int.tryParse(qtyC.text)??0, 'barcode':DateTime.now().millisecondsSinceEpoch.toString()}); Navigator.pop(context); ld(); }, child:const Text('حفظ'))]));
  }
  @override Widget build(BuildContext c){
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المخزون', style:TextStyle(fontWeight:FontWeight.bold)), backgroundColor:const Color(0xFF0F172A), foregroundColor:Colors.white, actions:[IconButton(icon:const Icon(Icons.add), onPressed:addDialog)]),
      body: Column(children:[
        Padding(padding:const EdgeInsets.all(12), child: TextField(onChanged:(v)=>setState(()=>q=v), decoration:InputDecoration(prefixIcon:const Icon(Icons.search), hintText:'ابحث في المخزون...', filled:true, fillColor:Theme.of(context).cardColor, border:OutlineInputBorder(borderRadius:BorderRadius.circular(12), borderSide:BorderSide.none)), textAlign:TextAlign.right)),
        Expanded(child: ListView.builder(padding:const EdgeInsets.all(12), itemCount:filtered.length, itemBuilder:(_,i){ final p=filtered[i]; final qty=p['stockQuantity'] as int; final isLow = qty < 10; return Container(margin:const EdgeInsets.only(bottom:12), decoration:BoxDecoration(color:Theme.of(context).cardColor, borderRadius:BorderRadius.circular(16), border: isLow? Border.all(color:Colors.red.withOpacity(0.3)):null), child: ListTile(leading:Container(width:50,height:50,decoration:BoxDecoration(color:isLow?Colors.red.withOpacity(0.1):Colors.green.withOpacity(0.1), shape:BoxShape.circle), child:Icon(isLow? Icons.warning_amber: Icons.inventory_2, color:isLow? Colors.red: Colors.green)), title:Text(p['name'], style:const TextStyle(fontWeight:FontWeight.bold)), subtitle:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Text('السعر: ${p['price']} ر.ي'), LinearProgressIndicator(value: (qty/100).clamp(0,1).toDouble(), color:isLow? Colors.red: Colors.green, backgroundColor:Colors.grey.withOpacity(0.2))]), trailing:Column(mainAxisAlignment:MainAxisAlignment.center, children:[Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6), decoration:BoxDecoration(color:isLow? Colors.red: Colors.green, borderRadius:BorderRadius.circular(20)), child:Text('$qty متبقي', style:const TextStyle(color:Colors.white, fontSize:12, fontWeight:FontWeight.bold))), if(isLow) const Padding(padding:EdgeInsets.only(top:4), child:Text('ناقص!', style:TextStyle(color:Colors.red, fontSize:10, fontWeight:FontWeight.bold)))]),)); }))
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed:addDialog, backgroundColor:const Color(0xFF0F172A), foregroundColor:Colors.white, icon:const Icon(Icons.add), label:const Text('منتج جديد')),
    );
  }
}
