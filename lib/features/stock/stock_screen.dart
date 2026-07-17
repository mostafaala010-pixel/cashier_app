import 'package:flutter/material.dart';
import '../../core/db/db.dart';
import '../../core/theme/theme.dart';

class StockScreen extends StatefulWidget { const StockScreen({super.key}); @override State<StockScreen> createState()=>_StockPro(); }
class _StockPro extends State<StockScreen>{
  List<Map<String,dynamic>> products=[];
  @override void initState(){super.initState(); load();}
  Future<void> load() async { final db=await AppDB.db; final r=await db.query('products', orderBy:'id DESC'); setState(()=>products=r); }
  Future<void> showAdd({Map<String,dynamic>? edit}) async {
    final nameC=TextEditingController(text: edit?['name']?.toString()??'');
    final priceC=TextEditingController(text: edit?['price']?.toString()??'');
    final qtyC=TextEditingController(text: edit?['qty']?.toString()??'');
    final barC=TextEditingController(text: edit?['barcode']?.toString()??'');
    await showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_)=> Container(decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))), padding: EdgeInsets.fromLTRB(20,20,20, MediaQuery.of(context).viewInsets.bottom+20), child: Column(mainAxisSize: MainAxisSize.min, children:[
      Container(width:40, height:4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
      const SizedBox(height:16),
      Text(edit==null? 'اضافة منتج احترافي' : 'تعديل المنتج', style: const TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
      const SizedBox(height:16),
      TextField(controller: nameC, decoration: _dec('اسم المنتج', Icons.inventory)),
      const SizedBox(height:12),
      Row(children:[Expanded(child: TextField(controller: priceC, keyboardType: TextInputType.number, decoration: _dec('السعر ر.ي', Icons.attach_money))), const SizedBox(width:12), Expanded(child: TextField(controller: qtyC, keyboardType: TextInputType.number, decoration: _dec('الكمية', Icons.numbers)))]),
      const SizedBox(height:12),
      TextField(controller: barC, decoration: _dec('الباركود (اختياري)', Icons.qr_code, suffix: IconButton(icon: const Icon(Icons.qr_code_scanner, color: ProTheme.green), onPressed: (){ barC.text = DateTime.now().millisecondsSinceEpoch.toString().substring(5); })),
      ),
      const SizedBox(height:20),
      SizedBox(width: double.infinity, height:50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: ProTheme.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () async {
        final db=await AppDB.db;
        if(edit==null){ await db.insert('products', {'name':nameC.text, 'price':double.tryParse(priceC.text)??0, 'qty':int.tryParse(qtyC.text)??0, 'barcode':barC.text, 'image':''}); }
        else { await db.update('products', {'name':nameC.text, 'price':double.tryParse(priceC.text)??0, 'qty':int.tryParse(qtyC.text)??0, 'barcode':barC.text}, where:'id=?', whereArgs:[edit['id']]); }
        Navigator.pop(context); load();
      }, child: Text(edit==null? 'حفظ المنتج':'تحديث', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
    ])));
  }
  InputDecoration _dec(String l, IconData ic, {Widget? suffix}){ return InputDecoration(labelText:l, prefixIcon: Icon(ic, size:20), suffixIcon: suffix, filled:true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)); }
  @override Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness==Brightness.dark;
    if(products.isEmpty){ return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Icon(Icons.inventory_2_outlined, size:80, color: Colors.grey[400]), const SizedBox(height:12), const Text('المخزون فارغ - اضف اول منتج'), const SizedBox(height:12), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: ProTheme.green), onPressed: ()=> showAdd(), icon: const Icon(Icons.add, color: Colors.white), label: const Text('اضافة منتج', style: TextStyle(color: Colors.white)))])); }
    return Column(children:[
      Container(margin: const EdgeInsets.all(12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: const LinearGradient(colors:[ProTheme.primary, ProTheme.cardDark]), borderRadius: BorderRadius.circular(16)), child: Row(children:[Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('اجمالي الاصناف', style: TextStyle(color: Colors.white60, fontSize:12)), Text('${products.length} منتج', style: const TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.bold)), const SizedBox(height:8), Text('قيمة المخزون: ${products.fold(0.0, (s,e)=> s + (e['price'] as num)*(e['qty'] as int)).toStringAsFixed(0)} ر.ي', style: const TextStyle(color: Colors.white70, fontSize:12))])), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: ProTheme.green.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.warehouse, color: ProTheme.green, size:30))]),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal:12), itemCount: products.length, itemBuilder: (_,i){
        final p=products[i]; final int qty=p['qty'] as int; final bool low=qty<=5;
        return Container(margin: const EdgeInsets.only(bottom:10), decoration: BoxDecoration(color: isDark? ProTheme.cardDark: Colors.white, borderRadius: BorderRadius.circular(14), border: low? Border.all(color: Colors.red.withOpacity(0.4)): null), child: ListTile(
          leading: Container(width:48, height:48, decoration: BoxDecoration(color: low? Colors.red.withOpacity(0.15): ProTheme.green.withOpacity(0.15), borderRadius: BorderRadius.circular(12)), child: Icon(low? Icons.warning: Icons.inventory_2, color: low? Colors.red: ProTheme.green)),
          title: Text(p['name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize:14)),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const SizedBox(height:4), Row(children:[Container(padding: const EdgeInsets.symmetric(horizontal:6, vertical:2), decoration: BoxDecoration(color: ProTheme.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Text('${p['price']} ر.ي', style: const TextStyle(fontSize:11, color: ProTheme.green, fontWeight: FontWeight.bold))), const SizedBox(width:6), Text('الكمية: $qty', style: TextStyle(fontSize:11, color: low? Colors.red: Colors.grey, fontWeight: low? FontWeight.bold: FontWeight.normal))]), const SizedBox(height:2), Text('باركود: ${p['barcode']}', style: const TextStyle(fontSize:10, color: Colors.grey))]),
          trailing: PopupMenuButton(itemBuilder: (_)=> [const PopupMenuItem(value:'edit', child: Text('تعديل')), const PopupMenuItem(value:'del', child: Text('حذف', style: TextStyle(color: Colors.red)))], onSelected: (v) async { if(v=='edit'){ showAdd(edit:p);} else { final db=await AppDB.db; await db.delete('products', where:'id=?', whereArgs:[p['id']]); load(); } }),
        ));
      }))
    ]);
  }
}
