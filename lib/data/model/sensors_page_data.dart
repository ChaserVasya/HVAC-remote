import 'dart:math';

class SensorsPageData {
  List<dynamic> temp() {
    double tempInHour(int hour) {
      return -0.05 * pow(hour - 12, 2) + 3;
    }

    int mapQuantity = 24;
    double minError = -0.5;
    double maxError = 0.5;

    double range = maxError - minError;

    Random rdm = Random();

    List testData = [];

    for (int i = 0; i < mapQuantity; i++) {
      var date = DateTime(2017).add(Duration(days: i));
      testData.add(
        <String, Object>{
          "Date": '${date.day}.${date.month}.${date.year}',
          "Close": (rdm.nextDouble()) * range + tempInHour(i),
        },
      );
    }
    return testData;
  }

  List<dynamic> air() {
    int mapQuantity = 50;
    int minValue = 6000;
    int maxValue = 10000;

    int range = maxValue - minValue;

    Random rdm = Random();

    List testData = [];

    for (int i = 0; i < mapQuantity; i++) {
      var date = DateTime(2017).add(Duration(days: i));
      testData.add(
        <String, Object>{
          "Date": '${date.day}.${date.month}.${date.year}',
          "Close": (rdm.nextDouble()) * range + minValue,
        },
      );
    }
    return testData;
  }
}
