import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiktok_clone2/Pages/Authentication/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok_clone2/Pages/Home/homeScreen.dart';
import 'package:tiktok_clone2/firebase_options.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
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
