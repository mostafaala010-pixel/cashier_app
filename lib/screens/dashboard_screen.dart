import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class DashboardScreen extends StatelessWidget { const DashboardScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text('لوحة التحكم')), body: Center(child: Column(children: [const Text('الأرباح والمبيعات'), SizedBox(height: 200, child: PieChart(PieChartData(sections: [PieChartSectionData(value: 60, color: Colors.blue), PieChartSectionData(value: 40, color: Colors.green)])))]))); } }
