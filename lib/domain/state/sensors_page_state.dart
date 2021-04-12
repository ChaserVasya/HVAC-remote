import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:my_mqtt/data/sensors_page_data.dart';

class SensorsPageState extends ChangeNotifier {
  SensorsPageData _sensorsPageData = SensorsPageData();

  get temp => _sensorsPageData.temp();
  get air => _sensorsPageData.air();
}
