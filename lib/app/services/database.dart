import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  var firestore = FirebaseFirestore.instance;
  CollectionReference get usersCollection => firestore.collection('Users');
}
