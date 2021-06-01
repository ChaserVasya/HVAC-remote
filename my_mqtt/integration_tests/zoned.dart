import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_mqtt/application/service_locator.dart';
import 'package:provider/provider.dart';

void main() {
  ZonedCatcher().runZonedApp();
}

class ZonedCatcher {
  final navigatorKey = GlobalKey<NavigatorState>();

  void runZonedApp() {
    runZonedGuarded<void>(
      () {
        WidgetsFlutterBinding.ensureInitialized();

        //FlutterError.onError = (details) => print('flutter error');
        runApp(Application(navigatorKey));
      },
      _onError,
    );
  }

  void _onError(Object exception, _) => _showException(exception);

  void _showException(Object exception) async {
    if (navigatorKey.currentContext == null) await Future.delayed(Duration(seconds: 7));
    print('runZoned error: $exception');
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (newContext) => ExceptionAlertDialog(newContext),
    );
  }
}

class ExceptionAlertDialog extends AlertDialog {
  ExceptionAlertDialog(BuildContext materialContext)
      : super(
          title: const Text('Exception!'),
          content: const Text('exception'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(materialContext).pop();
              },
              child: const Text('Ок'),
            ),
          ],
        );
}

enum Pages {
  first,
  second,
}

class Application extends StatelessWidget {
  Application(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    //throw MyException;
    return MultiProvider(
      providers: [ChangeNotifierProvider<ViewModel>(create: (context) => ViewModel(context))],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/first': (_) => PageTemplate(Pages.first),
          '/second': (_) => PageTemplate(Pages.second),
        },
        initialRoute: '/first',
      ),
    );
  }
}

class PageTemplate extends StatefulWidget {
  const PageTemplate(this.page);

  final Pages page;

  @override
  _PageTemplateState createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  @override
  void initState() async {
    //Future.delayed(Duration(seconds: 1), () => throw Exception);
    await initServices();
    super.initState();
    //throw Exception;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text((widget.page == Pages.first) ? 'First' : 'Second')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThrowerButton(context),
            ChangePageButton(context, (widget.page == Pages.first) ? '/second' : '/first'),
          ],
        ),
      ),
    );
  }
}

class ThrowerButton extends ElevatedButton {
  ThrowerButton(BuildContext context)
      : super(
          child: Text('throw'),
          //onPressed: context.watch<ViewModel>().throwException,
          onPressed: () => throw MyException,
        );
}

class ChangePageButton extends ElevatedButton {
  ChangePageButton(BuildContext context, String routeName)
      : super(
          child: Text('switch'),
          onPressed: () => Navigator.of(context).pushNamed(routeName),
        );
}

class ViewModel extends ChangeNotifier {
  ViewModel(this.context);

  final BuildContext context;

  void throwException() {
    _throwingCallback();
  }

  void _zonedWrapper(void Function() fnc) {
    runZonedGuarded(fnc, (_, __) => print('innerZoned catched'));
  }

  void _throwingCallback() {
    throwFutureException(3);
    throwFutureException(5);
  }
}

Future<void> throwFutureException(int seconds) async {
  print('waiting throw...');
  await Future.delayed(
    Duration(seconds: seconds),
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
