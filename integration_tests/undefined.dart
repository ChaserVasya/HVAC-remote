import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  var onError = (Object obj, StackTrace stack) {
    print('=========OUTER RUNZONED: $obj=====');
  };

  runZonedGuarded(
    () => runApp(MyApp()),
    onError,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    showDialog(context: context, builder: builder)
    return MultiProvider(
      providers: [ChangeNotifierProvider<ViewModel>(create: (context) => ViewModel(context))],
      child: MaterialApp(
        home: Scaffold(
          body: Body(),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Thrower(),
    );
  }
}

class Catcher extends StatelessWidget {
  Catcher({required this.child});

  void onError(Object object) {
    print('caughed: $object');
  }

  final Widget child;
  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (e) {
      onError(e);
      return Text('CAUGHED');
    }
  }
}

class Thrower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('throw'),
      onPressed: context.watch<ViewModel>().throwException,
    );
  }
}

class ViewModel extends ChangeNotifier {
  ViewModel(this.context);

  final BuildContext context;

  void _catchError(Function fnc) async {
    try {
      await fnc();
    } catch (e) {
      print('===INNER CATCH: "$e"====');
      if (e is num) {
        e.
      }
    }
  }

  void throwException() {
    _catchError(throwFutureException);
  }
}

Future<void> throwFutureException() async {
  print('waiting throw...');
  await Future.delayed(
    Duration(seconds: 1),
    () {
      print('throwed');
      throw MyException();
    },
  );
}

class MyException extends FirebaseAuthException {
  MyException()
      : super(
          code: 'code',
          message: 'message',
          email: 'email',
          phoneNumber: 'phoneNumber',
          tenantId: 'tenantId',
        );
}
