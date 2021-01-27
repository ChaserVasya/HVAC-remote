import 'package:flutter/material.dart';

import 'my_page_drawer.dart';

class MyPage extends StatelessWidget {
  MyPage({@required this.title, @required this.body, this.drawerNotNeeded = false});

  final String title;
  final Widget body;
  final bool drawerNotNeeded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (drawerNotNeeded) ? null : MyPageDrawer(),
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}
