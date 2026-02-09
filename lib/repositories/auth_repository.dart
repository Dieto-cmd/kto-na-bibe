import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kto_na_bibe/models/biba_user.dart';

abstract class AuthRepository {
  Future<void> logInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(String email, String password);
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<void> signInWithGoogle();
  Future<void> logOut();
  bool isUserLoggedIn();
  Stream<BibaUser?> get user;
}

const String _webClientID =
    "653064783691-pp7e9ipd7ghguhsvgblcrvca69vcldvp.apps.googleusercontent.com";

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
  Future<void> signInWithGoogle() async {
    try {
      GoogleSignIn.instance.initialize(serverClientId: _webClientID);
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Error: ${e.toString()}");
      throw "Error trying to log in with Google";
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
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null || (user?.emailVerified ?? false)) {
      await user?.sendEmailVerification();
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    await user.reload();
    return _auth.currentUser?.emailVerified == true;
  }

  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }
}

BibaUser? _bibaUserFromFireBaseUser(User? user) {
  return user == null ? null : BibaUser(uid: user.uid);
}
