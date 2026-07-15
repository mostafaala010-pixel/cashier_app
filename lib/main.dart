import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart';
import 'screens/cashier_screen.dart';

void main() {
  runApp(
    // حقن كلاس السلة في جذر التطبيق ليكون متاحاً لكافة الواجهات
    ChangeNotifierProvider(
      create: (_) => CartController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الكاشير الذكي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // جعل شاشة الكاشير هي الشاشة الرئيسية للتطبيق
      home: const CashierScreen(),
    );
  }
}