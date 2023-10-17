import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';
import 'package:tiktok_clone2/firebase_options.dart';

import 'Pages/Home/UserPage/userProfileScreen.dart';

 Future<void>main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tick Tock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(



      ),
      home: const LoginScreen(),
    );


  }
}


