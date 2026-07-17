import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'features/cashier/cashier_screen.dart';
import 'features/stock/stock_screen.dart';
import 'features/invoices/invoices_screen.dart';
import 'features/settings/settings_screen.dart';

void main(){ WidgetsFlutterBinding.ensureInitialized(); runApp(const ProPOSApp()); }
class ProPOSApp extends StatefulWidget { const ProPOSApp({super.key}); @override State<ProPOSApp> createState()=>_AppState(); }
class _AppState extends State<ProPOSApp>{
  bool isDark=true;
  int idx=0;
  @override Widget build(BuildContext context){
    final pages = [const CashierScreen(), const StockScreen(), const InvoicesScreen(), SettingsScreen(isDark:isDark, onToggle: ()=> setState(()=> isDark=!isDark))];
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: isDark? ProTheme.dark: ProTheme.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(['نظام الكاشير الاحترافي','المخزون الذكي','الفواتير والمبيعات','الاعدادات'][idx]),
          actions: [IconButton(icon: Icon(isDark? Icons.light_mode: Icons.dark_mode), onPressed: ()=> setState(()=> isDark=!isDark))],
        ),
        body: pages[idx],
        bottomNavigationBar: NavigationBar(selectedIndex: idx, onDestinationSelected: (i)=> setState(()=> idx=i), backgroundColor: isDark? ProTheme.cardDark: Colors.white, indicatorColor: ProTheme.green.withOpacity(0.2), destinations: const [
          NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale, color: ProTheme.green), label:'الكاشير'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2, color: ProTheme.green), label:'المخزون'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long, color: ProTheme.green), label:'الفواتير'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings, color: ProTheme.green), label:'الاعدادات'),
        ]),
      ),
    );
  }
}
