
import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
class StockScreen extends StatefulWidget { const StockScreen({super.key}); @override State<StockScreen> createState()=>_St(); }
class _St extends State<StockScreen> {
  List<Map<String,dynamic>> pr=[];
  @override void initState(){super.initState(); ld();}
  Future<void> ld() async { final db=await DatabaseHelper.instance.database; final r=await db.query('products'); setState(()=>pr=r); }
  Future<void> addDialog() async {
    final nameC=TextEditingController();
    final priceC=TextEditingController();
    final qtyC=TextEditingController();
    await showDialog(context:context, builder:(_)=> AlertDialog(title:const Text('اضافة منتج جديد'), content:Column(mainAxisSize:MainAxisSize.min, children:[TextField(controller:nameC, decoration:const InputDecoration(labelText:'اسم المنتج')), TextField(controller:priceC, decoration:const InputDecoration(labelText:'السعر'), keyboardType:TextInputType.number), TextField(controller:qtyC, decoration:const InputDecoration(labelText:'الكمية'), keyboardType:TextInputType.number)]), actions:[TextButton(onPressed:()=>Navigator.pop(context), child:const Text('الغاء')), ElevatedButton(onPressed:() async { final db=await DatabaseHelper.instance.database; await db.insert('products', {'name':nameC.text, 'price':double.tryParse(priceC.text)??0, 'stockQuantity':int.tryParse(qtyC.text)??0, 'barcode':''}); Navigator.pop(context); ld(); }, child:const Text('حفظ'))]));
  }
  @override Widget build(BuildContext context){
    return Scaffold(
      body: pr.isEmpty? const Center(child:Text('المخزون فارغ')): ListView.builder(itemCount:pr.length, itemBuilder:(_,i){ final p=pr[i]; return Card(margin:const EdgeInsets.symmetric(horizontal:12, vertical:6), child: ListTile(title:Text(p['name'].toString(), style:const TextStyle(fontWeight:FontWeight.bold)), subtitle:Text('السعر: ${p['price']} - الكمية: ${p['stockQuantity']}'), trailing: IconButton(icon:const Icon(Icons.delete, color:Colors.red), onPressed:() async { final db=await DatabaseHelper.instance.database; await db.delete('products', where:'id=?', whereArgs:[p['id']]); ld(); }))); }),
      floatingActionButton: FloatingActionButton.extended(onPressed:addDialog, backgroundColor:const Color(0xFF16A34A), icon:const Icon(Icons.add, color:Colors.white), label:const Text('اضافة منتج', style:TextStyle(color:Colors.white))),
    );
  }
}
