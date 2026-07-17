import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';
import '../controllers/settings_controller.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final settingsController = context.watch<SettingsController>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.store, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text('تطبيق الكاشير الذكي', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.dashboard), title: const Text('لوحة التحكم'), onTap: () => Navigator.pushNamed(context, '/dashboard')),
          ListTile(leading: const Icon(Icons.bar_chart), title: const Text('التقارير من-إلى'), onTap: () => Navigator.pushNamed(context, '/reports')),
          const Divider(),
          SwitchListTile(secondary: const Icon(Icons.dark_mode), title: const Text('الوضع الداكن'), value: themeController.isDarkMode, onChanged: (_) => themeController.toggleTheme()),
          ListTile(leading: const Icon(Icons.language), title: const Text('اللغة'), subtitle: Text(settingsController.language == 'ar' ? 'العربية' : 'English'), onTap: () { showDialog(context: context, builder: (_) => AlertDialog(title: const Text('اختر اللغة'), content: Column(mainAxisSize: MainAxisSize.min, children: [ListTile(title: const Text('العربية'), onTap: () { settingsController.setLanguage('ar'); Navigator.pop(context); }), ListTile(title: const Text('English'), onTap: () { settingsController.setLanguage('en'); Navigator.pop(context); })]))); }),
          ListTile(leading: const Icon(Icons.backup), title: const Text('النسخ الاحتياطي'), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة Drive قريبا')))),
          ListTile(leading: const Icon(Icons.print), title: const Text('الطباعة بلوتوث'), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اعدادات الطابعة')))),
        ],
      ),
    );
  }
}
