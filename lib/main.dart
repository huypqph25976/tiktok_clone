import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';
import 'package:tiktok_clone2/firebase_options.dart';

import 'Pages/Home/UserPage/userProfileScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD8xSXM3WMc8a11u1Dp4Dco8XJjpbawUnw',
      appId: '1:117938042068:android:2c128039076c3084f9b741',
      messagingSenderId: '117938042068',
      projectId: 'tiktok-clone-4fde1',
      storageBucket: 'tiktok-clone-4fde1.appspot.com',
    ),
  );
  const storage = FlutterSecureStorage();
  String? UID = await storage.read(key: 'uID');
  runApp(MyApp(UID: UID));
}

class MyApp extends StatelessWidget {
  final String? UID;
  const MyApp({super.key, this.UID});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tick Tock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: UID != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}
