import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, UserEX> userMap = <String, UserEX>{};

  final StreamController<Map<String, UserEX>> _usersController =
      StreamController<Map<String, UserEX>>();

  FirebaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
  }

  Stream<Map<String, UserEX>> get users => _usersController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  Map<String, UserEX> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      UserEX user = UserEX.fromMap(element.id, element.data());
      userMap[user.id] = user;
    }

    return userMap;
  }
}

class UserEX {
  UserEX({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.imageURL,
    required this.phone,
  });

  factory UserEX.fromMap(String id, Map<String, dynamic> data) {
    return UserEX(
        id: id,
        firstname: data['first_name'],
        lastname: data['last_name'],
        imageURL: data['imageURL'],
        phone: data['phone']);
  }

  final String id;
  final String firstname;
  final String lastname;
  final String imageURL;
  final String phone;
}
