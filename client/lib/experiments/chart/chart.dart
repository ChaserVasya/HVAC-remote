import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'time_series_chart.dart';
import 'time_series_data.dart';

void main() {
  runApp(const _MyApp());
}

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      locale: Locale('ru'),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: MyTimeSeriesChart(),
          ),
        ),
      ),
    );
  }
}

class MyTimeSeriesChart extends StatelessWidget {
  const MyTimeSeriesChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataRepository.instance.startData(refresh: false),
      builder: (_, AsyncSnapshot<List<TimeSeries>> snap) {
        if (snap.hasData) {
          final startData = buildSeries(snap.data!);

          return SizedBox(
            height: 500,
            child: TimeSeriesChart(
              seriesList: startData,
              viewport: DateTimeExtents(
                start: startData.single.data.first.dateTime,
                end: startData.single.data.last.dateTime,
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

List<Series<TimeSeries, DateTime>> buildSeries(List<TimeSeries> data) {
  return [
    Series<TimeSeries, DateTime>(
      id: 'Temperature',
      domainFn: (datum, _) => datum.dateTime,
      measureFn: (datum, _) => datum.value,
      data: data,
    ),
  ];
}
