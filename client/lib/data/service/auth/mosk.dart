import 'package:firebase_auth/firebase_auth.dart';
import 'package:hvac_remote_client/application/exception/exceptions.dart';

class MoskAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createAccount(String rawEmail, String password, String repeated) async {
    final email = rawEmail.trim();
    if (password.isEmpty) throw EmptyStringException();
    if (repeated != password) throw IncorrectRepeatedException();
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<bool> signIn(String rawEmail, String password) async {
    final email = rawEmail.trim();
    if (password.isEmpty) throw EmptyStringException();
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (!userCredential.user!.emailVerified) return false;
    return true;
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

  bool get wasAuthed => (_auth.currentUser == null) ? false : true;

  Future<void> sendPasswordResetEmail([String? rawEmail]) async {
    if (rawEmail == null) {
      await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
    } else {
      final email = rawEmail.trim();
      await _auth.sendPasswordResetEmail(email: email);
    }
  }

  Future<void> verifyPasswordResetCode(String code) async {
    await _auth.verifyPasswordResetCode(code);
  }
}
