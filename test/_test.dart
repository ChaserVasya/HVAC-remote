import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    //expect(tester.takeException(), isAssertionError); // or isNull, as appropriate.
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Catcher(
            child: Thrower(),
          ),
        ),
      ),
    );
  }
}

class Catcher extends StatelessWidget {
  Catcher({required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (e) {
      print('=======================================handled: $e =======================================');
      rethrow;
    }
  }
}

class Thrower extends StatelessWidget {
  void throwException() {
    Future.delayed(
      Duration(seconds: 2),
      () {
        print('=======================================throwing=======================================');
        throw Exception;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    throwException();
    return Text('heh');
  }
}
