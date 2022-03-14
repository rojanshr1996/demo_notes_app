import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app_bloc/model/auth_user.dart';
import 'package:demo_app_bloc/services/auth_exceptions.dart';
import 'package:demo_app_bloc/services/cloud/cloud_note.dart';
import 'package:demo_app_bloc/services/cloud/cloud_storage_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final users = FirebaseFirestore.instance.collection('users');

  Future<AuthUser> signUp({required String email, required String password, required String fullName}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser;
      updateUserName(fullName);
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

  updateUserName(String fullName) async {
    User? user = _firebaseAuth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.userId = user.uid;
    userModel.name = fullName;
    userModel.profileImage = user.photoURL;
    try {
      await users.doc(user.uid).set({
        fullNameFieldName: userModel.name,
        profileImageFieldName: userModel.profileImage,
        emailFieldName: userModel.email,
        userIdFieldName: userModel.userId,
      });
    } catch (e) {
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
    } catch (_) {
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
      throw GenericAuthException();
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

  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'firebase_auth/inavalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'firebase_auth/user-not-found') {
        throw UserNotFoundException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
}
