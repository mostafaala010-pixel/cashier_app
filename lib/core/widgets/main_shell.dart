
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../features/cashier/cashier_screen.dart';
import '../../features/sales/sales_screen.dart';
import '../../features/stock/stock_screen.dart';
import '../../features/invoices/invoices_screen.dart';
import '../../features/customers/customers_screen.dart';
import '../../features/reports/reports_screen.dart';

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState()=>_M(); }

class _M extends State<MainShell> {
  int idx=0;
  bool isDark=true;
  final pages = const [CashierScreen(), SalesScreen(), StockScreen(), InvoicesScreen(), CustomersScreen(), ReportsScreen()];
  final titles = const ['الكاشير','المبيعات','المخزون','الفواتير','العملاء','التقارير'];
  @override Widget build(BuildContext c){
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: isDark? AppTheme.dark : AppTheme.light,
      home: Builder(builder: (ctx){
        return Scaffold(
          appBar: AppBar(title: Text(titles[idx], style: const TextStyle(fontWeight:FontWeight.bold))),
          drawer: Drawer(child: ListView(children:[
            DrawerHeader(decoration: const BoxDecoration(color: Color(0xFF0F172A)), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: const [Icon(Icons.store, color:Colors.white, size:40), SizedBox(height:10), Text('نظام الكاشير', style:TextStyle(color:Colors.white, fontSize:20, fontWeight:FontWeight.bold)), Text('النسخة الاحترافية', style:TextStyle(color:Colors.white70))])),
            _drawerItem(0, Icons.point_of_sale, 'الكاشير'),
            _drawerItem(1, Icons.shopping_bag, 'المبيعات'),
            _drawerItem(2, Icons.inventory_2, 'المخزون'),
            _drawerItem(3, Icons.receipt_long, 'الفواتير'),
            _drawerItem(4, Icons.people, 'العملاء'),
            _drawerItem(5, Icons.bar_chart, 'التقارير'),
            const Divider(),
            ListTile(leading: Icon(isDark? Icons.light_mode: Icons.dark_mode), title: Text(isDark? 'الوضع النهاري':'الوضع الليلي'), onTap:(){setState(()=>isDark=!isDark); Navigator.pop(ctx);} )
          ])),
          body: pages[idx],
        );
      }),
    );
  }
  Widget _drawerItem(int i, IconData ic, String t){
    final sel = idx==i;
    return ListTile(
      leading: Icon(ic, color: sel? Colors.green: null),
      title: Text(t, style: TextStyle(fontWeight: sel? FontWeight.bold: FontWeight.normal, color: sel? Colors.green: null)),
      selected: sel,
      onTap:(){ setState(()=>idx=i); Navigator.pop(context); },
    );
  }
}
