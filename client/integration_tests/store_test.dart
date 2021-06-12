import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Page(),
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ElevatedButton(
        onPressed: test,
        child: Text('heh'),
      ),
    );
  }
}

void test() async {
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'v.chaser@mail.ru',
    password: 'qwerty',
  );
  final store = FirebaseFirestore.instance;
  final res = (await store.collection('roles').get()).docs;
  print('===================$res================');
}
