import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/cart_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/settings_controller.dart';
import 'app_shell.dart';
import 'screens/dashboard_screen.dart';
import 'screens/reports_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeController.lightTheme,
            darkTheme: themeController.darkTheme,
            themeMode: themeController.isDarkMode? ThemeMode.dark : ThemeMode.light,
            home: const AppShell(),
            routes: {
              '/dashboard': (_) => const DashboardScreen(),
              '/reports': (_) => const ReportsScreen(),
            },
          );
        },
      ),
    );
  }
}