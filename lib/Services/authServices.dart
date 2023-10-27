import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginscreen.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginwithemail.dart';
import 'package:tiktok_clone2/Pages/Home/Notification/NotificationService.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';
import 'package:tiktok_clone2/Widgets/snackBar.dart';
import 'package:tiktok_clone2/Services/userService.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  static final notifications = NotificationsService();

  static loginFetch(
      {required BuildContext context,
      required email,
      required password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      const storage = FlutterSecureStorage();
      String? uID = userCredential.user?.uid.toString();
      await storage.write(key: 'uID', value: uID);
      await notifications.requestPermission();
      await notifications.getToken();

      FocusScope.of(context).unfocus();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
      getSnackBar(
        'Login',
        'Login Success.',
        Colors.green,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        getSnackBar(
          'Login',
          'No user found for that email.',
          Colors.red,
        ).show(context);
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print(e.code);

        getSnackBar(
                'Login', 'Wrong password provided for that user.', Colors.red)
            .show(context);
        //print('Wrong password provided for that user.');
      }
    }
  }

  static Logout({required BuildContext context}) async {
    try {
      FirebaseAuth.instance.signOut();
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      getSnackBar(
        'Logout',
        'Logout Success.',
        Colors.green,
      ).show(context);
    } catch (e) {}
  }

  static registerFetch(
      {required BuildContext context,
      required email,
      required password,
      required username,
      required uid}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await UserService.addUser(
          UID: userCredential.user?.uid, username: username, email: email);
      await notifications.requestPermission();
      await notifications.getToken();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginWithEmail()),
        (route) => false,
      );
      getSnackBar(
        'Register',
        'Register Success.',
        Colors.green,
      ).show(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //print('The password provided is too weak.');
        getSnackBar(
          'Register',
          'The password provided is too weak.',
          Colors.red,
        ).show(context);
      } else if (e.code == 'email-already-in-use') {
        getSnackBar(
          'Register',
          'The account already exists for that email.',
          Colors.red,
        ).show(context);
        //print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
