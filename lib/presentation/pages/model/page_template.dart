import 'package:flutter/material.dart';

import 'page_drawer_template.dart';

class PageTemplate extends StatelessWidget {
  PageTemplate({
    @required this.title,
    @required this.body,
    this.drawerIsNeed = true,
    this.padding,
  });

  final String title;
  final Widget body;
  final bool drawerIsNeed;
  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry _defaultPadding = EdgeInsets.all(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (drawerIsNeed) ? PageDrawerTemplate() : null,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: padding ?? _defaultPadding,
        child: body,
      ),
    );
  }
}
