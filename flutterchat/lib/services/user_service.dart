import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<String>> getAllRegisteredUsers() async {
    List<String> users = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>; // add "as Map<String, dynamic>"
        String name = data['name'];
        String email = data['email'];

        String user = name.isNotEmpty ? name : email;
        users.add(user);
      });

      return users;
    } catch (e) {
      print('Error fetching registered users: $e');
      return [];
    }
  }
}
