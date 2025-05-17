class MyUser {
  final String uid;

  MyUser({required this.uid});

  factory MyUser.fromFirebaseUser(dynamic user) {
    return MyUser(uid: user.uid);
  }
}
