import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/application/exception_domain/custom/alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/exceptions.dart';

class AuthUseCases {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> createAccount(String email, String password, String repeatedPassword) async {
    if (repeatedPassword != password) throw IncorrectRepeatedPasswordException;
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> logIn(String email, String password) async {
    var userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (!userCredential.user!.emailVerified) throw const EmailNotVerifiedException();
  }

  Future<void> changeRole(String password) {
    return _functions.httpsCallable('changeRole').call(password);
  }

  Future<void> logOut() {
    return _auth.signOut();
  }

  Future<void> sendVerifyingEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      print('verified email sended');
    } catch (e) {
      if (e is EmailNotVerifiedException) {
        print('[EmailVerifyingException] has been thrown in [sendVerifyingEmail]');
        //TODO disallow throwing an [EmailVerifyingException]
        //? Why [sendEmailVerification] throws [EmailVerifyingException]?
        //? We just for this purpose send a verifying letter to mail
        return;
      } else {
        rethrow;
      }
    }
  }
}
