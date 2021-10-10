class Averager {
  Averager._();

  static List<int> reduceByAveraging(int targetAmount, List<int> source) {
    final valuesPerAverage = source.length ~/ targetAmount;

    if (valuesPerAverage < 1) throw Exception();

    final newValues = List.generate(
      targetAmount,
      (i) {
        final start = i * valuesPerAverage;
        final end = (i + 1) * valuesPerAverage;

        final valuesForAveraging = source.getRange(start, end);
        return _average(valuesForAveraging);
      },
      growable: false,
    );

    return newValues;
  }

  static int _average(Iterable<int> source) {
    final average = source.reduce((sum, e) => e + sum) / source.length;
    return average.round();
  }
}
