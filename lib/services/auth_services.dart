import 'package:demo_app_bloc/model/auth_user.dart';
import 'package:demo_app_bloc/services/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<AuthUser> signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailInUseAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      // throw Exception(e.toString());
      throw GenericAuthException();
    }
  }

  Future<AuthUser?> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
    return null;
  }

  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.frmFirebase(user);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseAuth.signOut();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseAuth.currentUser?.sendEmailVerification();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      // throw Exception(e);
      throw GenericAuthException();
    }
  }
}
