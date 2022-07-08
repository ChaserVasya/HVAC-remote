abstract class AuthService {
  Future<void> createAccount(String email, String password, String repeated);
  Future<bool> signIn(String email, String password);
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<void> deleteAccount();
  bool get wasAuthed;
  Future<void> sendPasswordResetEmail([String? email]);
  Future<void> verifyPasswordResetCode(String code);
}
