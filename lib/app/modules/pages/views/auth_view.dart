import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heatlth_monitor/app/data/constants.dart';
import 'package:heatlth_monitor/app/modules/pages/views/add_device.dart';
import 'package:heatlth_monitor/app/modules/pages/views/select_device.dart';
import 'package:heatlth_monitor/app/modules/pages/views/sign_in.dart';

import '../../../services/auth.dart';

class AuthView extends StatefulWidget {
  final AuthBase auth;
  const AuthView({Key? key, required this.auth}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GiveUser?>(
      stream: widget.auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          GiveUser? user = snapshot.data;
          if (user == null) {
            return LoginPage(
              auth: widget.auth,
            );
          }
          String uid = FirebaseAuth.instance.currentUser!.uid;
          return CheckNewUser(uid: uid, auth: widget.auth);
          // return SelectDevice(auth: widget.auth, uid: uid);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: kMainColor),
            ),
          );
        }
      },
    );
  }
}

class CheckNewUser extends StatefulWidget {
  final String uid;
  final AuthBase auth;
  const CheckNewUser({Key? key, required this.uid, required this.auth})
      : super(key: key);

  @override
  State<CheckNewUser> createState() => _CheckNewUserState();
}

class _CheckNewUserState extends State<CheckNewUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: kMainColor),
          );
        }
        bool newUser = snapshot.data!["New user"];
        return newUser
            ? AddDevice(
                auth: widget.auth,
                uid: widget.uid,
              )
            : SelectDevice(uid: widget.uid, auth: widget.auth);
      },
    );
  }
}
