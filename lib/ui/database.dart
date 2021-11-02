import 'package:auth/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods extends FirebaseService {
  //static final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Stream<QuerySnapshot>> getUserByUserName(String name) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("first_name", isEqualTo: name)
        .snapshots();
  }

  Future getData(String collection) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _db.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('first_name', isGreaterThanOrEqualTo: queryString)
        .get();
  }
}
