import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'database.dart';

final _auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class GiveUser {
  GiveUser({required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<GiveUser?> get onAuthStateChanged;
  Future<GiveUser?> currentUser();
  Future<GiveUser?> signInWithGoogle(RoundedLoadingButtonController controller);
  Future<void> signOut();
}

class Auth implements AuthBase {
  GiveUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return GiveUser(uid: user.uid);
  }

  var db = DataBase();
  @override
  Stream<GiveUser?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<GiveUser?> currentUser() async {
    final user = _auth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<GiveUser?> signInWithGoogle(
      RoundedLoadingButtonController controller) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        if (authResult.additionalUserInfo!.isNewUser) {
          await db.usersCollection.doc(_auth.currentUser!.uid).set({
            'Username': authResult.user!.displayName,
            'Email': authResult.user!.email,
            'Profile Picture': authResult.user!.photoURL,
            'New user': authResult.additionalUserInfo!.isNewUser,
          });
        }
        if (!authResult.additionalUserInfo!.isNewUser) {
          firestore.collection("Users").doc(_auth.currentUser!.uid).update({
            'New user': authResult.additionalUserInfo!.isNewUser,
          });
        }
        controller.success();

        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      controller.error();
      Get.snackbar("Error", "Sign In aborted by user!",
          backgroundColor: kWhiteColor);
      Timer(const Duration(seconds: 2), () {
        controller.reset();
      });
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
  Future<void> logout() => _auth.signOut();
}
