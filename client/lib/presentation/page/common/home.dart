import 'package:flutter/material.dart';
import 'package:hvac_remote_client/presentation/template/page_template.dart';
// import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      appBarTitle: 'Домашняя страница',
      body: Center(
        child: Text('My cute home'),
      ),
    );
  }
}
