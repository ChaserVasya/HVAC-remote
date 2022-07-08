import 'package:firebase_auth/firebase_auth.dart';
import 'package:hvac_remote_client/application/exception/exceptions.dart';
import 'package:hvac_remote_client/domain/service/auth.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> createAccount(String rawEmail, String password, String repeated) async {
    final email = rawEmail.trim();
    if (password.isEmpty) throw EmptyStringException();
    if (repeated != password) throw IncorrectRepeatedException();
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.sendEmailVerification();
  }

  @override
  Future<bool> signIn(String rawEmail, String password) async {
    final email = rawEmail.trim();
    if (password.isEmpty) throw EmptyStringException();
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    if (!userCredential.user!.emailVerified) return false;
    return true;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  @override
  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  @override
  bool get wasAuthed => (_auth.currentUser == null) ? false : true;

  @override
  Future<void> sendPasswordResetEmail([String? rawEmail]) async {
    if (rawEmail == null) {
      await _auth.sendPasswordResetEmail(email: _auth.currentUser!.email!);
    } else {
      final email = rawEmail.trim();
      await _auth.sendPasswordResetEmail(email: email);
    }
  }

  @override
  Future<void> verifyPasswordResetCode(String code) async {
    await _auth.verifyPasswordResetCode(code);
  }
}
