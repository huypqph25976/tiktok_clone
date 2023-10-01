import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  //Get userInfo from firestore cloud
  static Future getUserInfo() async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    const storage = FlutterSecureStorage();
    String? UID = await storage.read(key: 'uID');
    final result = await users.doc(UID).get();
    // final UserModel user = UserModel(
    //     gender: result.get('gender'),
    //     email: result.get('email'),
    //     phone: result.get('phone'),
    //     age: result.get('age'),
    //     avartaURL: result.get('avartaURL'),
    //     fullName: result.get('fullName'));
    //print(result.get('fullName'));
    return result;
  }

  static Stream getPeopleInfo(String peopleID) {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    final result = users.doc(peopleID).snapshots();
    // final UserModel user = UserModel(
    //     gender: result.get('gender'),
    //     email: result.get('email'),
    //     phone: result.get('phone'),
    //     age: result.get('age'),
    //     avartaURL: result.get('avartaURL'),
    //     fullName: result.get('fullName'));
    //print(result.get('fullName'));
    return result;
  }

  //Add user to firestore cloud after registering
  static addUser({
    required String? UID,
    required String username,
    required String email,
  }) {
    // Call the user's CollectionReference to add a new user
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      users
          .doc(UID)
          .set({
        'uID': UID,
        'username': username,
        'email': email,
        'following': [],
        'follower': [],
        'avartaURL':
        'https://iotcdn.oss-ap-southeast-1.aliyuncs.com/RpN655D.png',
        'phone': 'None',
        'age': 'None',
        'gender': 'None',
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {}
  }

  //Edit userInfo in firestore cloud



}