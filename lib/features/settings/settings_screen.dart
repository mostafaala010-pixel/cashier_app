import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.isDark, required this.onToggle});
  final bool isDark; final VoidCallback onToggle;
  @override Widget build(BuildContext context){
    return ListView(padding: const EdgeInsets.all(16), children:[
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors:[ProTheme.primary, ProTheme.cardDark]), borderRadius: BorderRadius.circular(20)), child: Row(children:[const CircleAvatar(radius:28, backgroundColor: ProTheme.green, child: Icon(Icons.store, color: Colors.white)), const SizedBox(width:12), const Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text('متجري', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:16)), Text('النسخة الاحترافية Pro', style: TextStyle(color: Colors.white60, fontSize:12))]), const Spacer(), IconButton(onPressed: (){}, icon: const Icon(Icons.edit, color: Colors.white70))]),
      ),
      const SizedBox(height:20),
      const Text('الاعدادات العامة', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height:10),
      _tile(context, Icons.dark_mode, 'الوضع الليلي', isDark? 'مفعل':'غير مفعل', trailing: Switch(value: isDark, activeColor: ProTheme.green, onChanged: (_)=> onToggle())),
      _tile(context, Icons.qr_code_scanner, 'ماسح الباركود', 'mobile_scanner جاهز', onTap: (){}),
      _tile(context, Icons.print, 'الطابعة', 'اعداد طابعة الفواتير', onTap: (){}),
      _tile(context, Icons.language, 'العملة', 'ر.ي يمني', onTap: (){}),
      const SizedBox(height:20),
      const Text('الدعم', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height:10),
      _tile(context, Icons.help, 'مساعدة', 'كيف استخدم النظام؟'),
      _tile(context, Icons.star, 'قيمنا', 'ادعمنا بتقييم 5 نجوم'),
    ]);
  }
  Widget _tile(BuildContext c, IconData ic, String t, String s, {Widget? trailing, VoidCallback? onTap}){ return Container(margin: const EdgeInsets.only(bottom:10), decoration: BoxDecoration(color: Theme.of(c).cardColor, borderRadius: BorderRadius.circular(14)), child: ListTile(leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: ProTheme.green.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(ic, color: ProTheme.green, size:20)), title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize:14)), subtitle: Text(s, style: const TextStyle(fontSize:11)), trailing: trailing?? const Icon(Icons.chevron_left), onTap: onTap));}
}
