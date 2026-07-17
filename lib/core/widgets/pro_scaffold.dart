import 'package:flutter/material.dart';
import '../theme/theme.dart';
class ProAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; final String subtitle; final List<Widget>? actions;
  const ProAppBar({super.key, required this.title, this.subtitle='', this.actions});
  @override Widget build(BuildContext context){
    return AppBar(
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
        if(subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.normal))
      ]),
      actions: actions,
      bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height:1, color: Colors.white10)),
    );
  }
  @override Size get preferredSize => const Size.fromHeight(64);
}
