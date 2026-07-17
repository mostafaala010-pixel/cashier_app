import 'package:flutter/material.dart';
import 'screens/cashier_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/invoices_screen.dart';
import 'screens/customers_screen.dart';
import 'widgets/main_drawer.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const CashierScreen(),
    const InventoryScreen(),
    const InvoicesScreen(),
    const CustomersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.point_of_sale), label: 'المبيعات'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'المخزون'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'الفواتير'),
          NavigationDestination(icon: Icon(Icons.people), label: 'العملاء'),
        ],
      ),
    );
  }
}
