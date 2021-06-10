import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/application/exception/custom/exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createAccount(String email, String password, String repeated) async {
    if (password.isEmpty) throw const EmptyPasswordException();
    if (repeated != password) throw const IncorrectrepeatedException();
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> signIn(String email, String password) async {
    if (password.isEmpty) throw const EmptyPasswordException();
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (!userCredential.user!.emailVerified) throw const EmailNotVerifiedException();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  Future<void> sendPasswordResetEmail() async {
    await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
  }

  Future<void> verifyPasswordResetCode(String code) async {
    await _auth.verifyPasswordResetCode(code);
  }
}
