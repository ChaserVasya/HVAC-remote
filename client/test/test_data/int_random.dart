import 'dart:math';

class SimplifiedIntRandom {
  final List<int> _randList = () {
    final rand = Random();
    List<int> randList = List.generate(_length, (_) => rand.nextInt(100));
    return randList;
  }();

  int _current = 0;

  static const _length = 1000;

  int next() {
    if (_current == _length) _current = 0;
    return _randList[_current++];
  }
}
