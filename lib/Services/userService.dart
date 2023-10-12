import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_clone2/Pages/Home/UserPage/userProfileScreen.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';
import 'package:tiktok_clone2/Widgets/snackBar.dart';

class UserService {
  //Get userInfo from firestore cloud
  static Future getUserInfo() async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    const storage = FlutterSecureStorage();
    String? UID = await storage.read(key: 'uID');
    final result = await users.doc(UID).get();

    return result;
  }

  static Stream getPeopleInfo(String peopleID) {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    final result = users.doc(peopleID).snapshots();

    return result;
  }


  static addUser({
    required String? UID,
    required String username,
    required String email,
  }) {
    // Call the user's CollectionReference to add a new user
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      users
          .doc(UID)
          .set({
        'uID': UID,
        'username': username,
        'email': email,
        'following': [],
        'follower': [],
        'avartarURL': 'https://iotcdn.oss-ap-southeast-1.aliyuncs.com/RpN655D.png',
        'phone': 'None',

      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {}
  }


  static editUserFetch(
      {required BuildContext context,
        required phone,
        required username}) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      final storage = const FlutterSecureStorage();
      String? UID = await storage.read(key: 'uID');
      users
          .doc(UID)
          .update({
        'username': username,
        'phone': phone,

      })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfileScreen()),
      );
      getSnackBar(
        'Edit Info',
        'Edit Success.',
        Colors.green,
      ).show(context);
    } catch (e) {
      getSnackBar(
        'Edit Info',
        'Edit Fail. $e',
        Colors.red,
      ).show(context);
      print(e);
    }
  }

  static editUserImage(
      {required BuildContext context, required ImageStorageLink}) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      final storage = const FlutterSecureStorage();
      String? UID = await storage.read(key: 'uID');
      users
          .doc(UID)
          .update({
        'avartarURL': ImageStorageLink,
      })
          .then((value) => print("User's Image Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      return false;
    } catch (e) {
      getSnackBar(
        'Edit Image',
        'Edit Fail. $e',
        Colors.red,
      ).show(context);
    }
  }

  static Future<void> follow(String uid) async {

    String currentUid = FirebaseAuth.instance.currentUser!.uid;
    print("$currentUid.........$uid");

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .get();
    if ((doc.data()! as dynamic)['following'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .update({
        'following': FieldValue.arrayRemove([uid]),
      });
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'follower': FieldValue.arrayRemove([currentUid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .update({
        'following': FieldValue.arrayUnion([uid]),
      });

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'follower': FieldValue.arrayUnion([currentUid]),
      });
    }
  }


}