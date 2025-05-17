import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of custom MyUser
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(
      (User? user) => user != null ? MyUser(uid: user.uid) : null,
    );
  }

  // Example sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Add signIn/register if needed
}
