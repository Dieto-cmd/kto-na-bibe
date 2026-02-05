import 'package:firebase_auth/firebase_auth.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

abstract class AuthRepository {
  Future<void> logInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(String email, String password);
  Future<void> logOut();
  bool isUserLoggedIn();
  Stream<BibaUser?> get user;
}

class FireBaseAuthRepository extends AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<BibaUser?> get user {
    return _auth.authStateChanges().map(
      (User? user) => _bibaUserFromFireBaseUser(user),
    );
  }

  @override
  bool isUserLoggedIn() {
    return _auth.currentUser == null ? false : true;
  }

  @override
  Future<void> logInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      throw "Couldn't log in with those credentials";
    } catch (_) {
      throw "Unknown error";
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      throw "Couldn't sign up in with those credentials";
    } catch (_) {
      throw "Unknown error";
    }
  }

  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }
}

BibaUser? _bibaUserFromFireBaseUser(User? user) {
  return user == null ? null : BibaUser(uid: user.uid);
}
