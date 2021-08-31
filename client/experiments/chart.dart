import 'package:flutter/material.dart';

import 'time_series_chart.dart';
import 'time_series_data.dart';

void main() {
  runApp(const _MyApp());
}

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru'),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 600,
                  child: MyTimeSeriesChart(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTimeSeriesChart extends StatelessWidget {
  MyTimeSeriesChart({Key? key}) : super(key: key);

  late final _chart = TimeSeriesChart(
    seriesList: startData,
    viewport: DateTimeExtents(
      start: startData.single.data.first.dateTime,
      end: startData.single.data.last.dateTime,
    ),
  );

  @override
  Widget build(BuildContext context) => _chart;
}

final startData = [
  Series<TimeSeries, DateTime>(
    id: 'Temperature',
    domainFn: (datum, _) => datum.dateTime,
    measureFn: (datum, _) => datum.value,
    data: DataProvider.instance.startData,
  ),
];
