import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_mqtt/application/service_locator.dart';

const String email = 'v.chaser@mail.ru';
const String password = 'mathematic5';

Future<void> main() async {
  print('main');

  await checkAuthState();

  print('/main');
}

Future<void> checkAuthState() async {
  print('checkAuthState');

  await init();
  print("=========================================================");
  final auth = sl<FirebaseAuth>();
  auth.userChanges().listen(checkClaims);

  print('/checkAuthState');
}

Future<void> init() async {
  print('init');

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  print('/init');
}

void checkClaims(User? user) async {
  print('checkClaims');

  final claims = (await user!.getIdTokenResult()).claims!;
  print(claims);

  print('/checkClaims');
}
