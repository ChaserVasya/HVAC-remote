import 'package:flutter/material.dart';

import 'drawer_template.dart';

class PageTemplate extends StatelessWidget {
  const PageTemplate({
    required this.title,
    required this.body,
    this.padding,
    this.drawerIsNeeded = true,
  });

  final String title;
  final Widget body;
  final bool drawerIsNeeded;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerIsNeeded ? DrawerTemplate() : null,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: padding ?? EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}
