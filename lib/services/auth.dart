import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(
      (User? user) => user != null ? MyUser(uid: user.uid) : null,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

}
