
import 'package:flutter/material.dart';
import 'core/database/database_helper.dart';
import 'features/sales/sales_screen.dart';
import 'features/stock/stock_screen.dart';
import 'features/invoices/invoices_screen.dart';
import 'features/customers/customers_screen.dart';

void main(){ runApp(const MyApp()); }

class MyApp extends StatefulWidget { const MyApp({super.key}); @override State<MyApp> createState()=>_MyAppState(); }
class _MyAppState extends State<MyApp> {
  ThemeMode mode = ThemeMode.light;
  void toggle(){ setState(()=> mode = mode==ThemeMode.light ? ThemeMode.dark : ThemeMode.light); }
  @override Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:'نظام الكاشير',
      themeMode: mode,
      theme: ThemeData(useMaterial3:true, colorSchemeSeed: const Color(0xFF0F172A), scaffoldBackgroundColor: const Color(0xFFF8FAFC), fontFamily: 'Cairo'),
      darkTheme: ThemeData(useMaterial3:true, brightness:Brightness.dark, colorSchemeSeed: const Color(0xFF0F172A)),
      home: HomeScreen(onToggle: toggle, mode: mode),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggle; final ThemeMode mode;
  const HomeScreen({super.key, required this.onToggle, required this.mode});
  @override State<HomeScreen> createState()=>_H();
}
class _H extends State<HomeScreen> {
  int idx=0;
  final pages=[const SalesScreen(), const StockScreen(), const InvoicesScreen(), const CustomersScreen()];
  @override Widget build(BuildContext c){
    return Scaffold(
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children:[
          DrawerHeader(decoration: const BoxDecoration(color:Color(0xFF0F172A)), child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: const [Icon(Icons.store,color:Colors.white,size:40), SizedBox(height:12), Text('نظام الكاشير الاحترافي',style:TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold)), Text('v2.0 عربي',style:TextStyle(color:Colors.white70)) ])),
          ListTile(leading:const Icon(Icons.point_of_sale), title:const Text('الكاشير'), onTap:(){ setState(()=>idx=0); Navigator.pop(c); }),
          ListTile(leading:const Icon(Icons.inventory_2), title:const Text('المخزون'), onTap:(){ setState(()=>idx=1); Navigator.pop(c); }),
          ListTile(leading:const Icon(Icons.receipt_long), title:const Text('الفواتير'), onTap:(){ setState(()=>idx=2); Navigator.pop(c); }),
          ListTile(leading:const Icon(Icons.people), title:const Text('العملاء'), onTap:(){ setState(()=>idx=3); Navigator.pop(c); }),
          const Divider(),
          SwitchListTile(value: widget.mode==ThemeMode.dark, onChanged:(v)=>widget.onToggle(), title: const Text('الوضع الليلي'), secondary: const Icon(Icons.dark_mode)),
          ListTile(leading:const Icon(Icons.language), title: const Text('اللغة: العربية'), subtitle: const Text('English soon')),
        ]),
      ),
      body: pages[idx],
      bottomNavigationBar: NavigationBar(selectedIndex: idx, onDestinationSelected:(i)=>setState(()=>idx=i), destinations: const [
        NavigationDestination(icon:Icon(Icons.point_of_sale_outlined), selectedIcon:Icon(Icons.point_of_sale), label:'الكاشير'),
        NavigationDestination(icon:Icon(Icons.inventory_2_outlined), selectedIcon:Icon(Icons.inventory_2), label:'المخزون'),
        NavigationDestination(icon:Icon(Icons.receipt_long_outlined), selectedIcon:Icon(Icons.receipt_long), label:'الفواتير'),
        NavigationDestination(icon:Icon(Icons.people_alt_outlined), selectedIcon:Icon(Icons.people), label:'العملاء'),
      ]),
    );
  }
}
