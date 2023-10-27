import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_clone2/Pages/Home/Notification/NotificationScreen.dart';

class NotificationsService {
  static const key =
      'AAAAG3WntNQ:APA91bElbsqg4BrxLzAof8LSNJ_vBvMEF-yL9Bh0Da4edg8W61n9NnMAspWV-bjcb0je1tAONppl7iWYRKuw6-qAgWXt1dHLc_L15hSm6oAAJRq9u8S4j2FBWdyd5G_XFdLvSF8xnNt0';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initLocalNotification() {
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true,
          requestSoundPermission: true);

      const initializationSettings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint(details.payload.toString());
        },
      );
    } catch (e) {
      print('=======================chết ở 1');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final styleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title,
          htmlFormatTitle: true);

      final androidDetails = AndroidNotificationDetails(
          'com.example.app_toptop.urgent', 'mychannelid',
          importance: Importance.max,
          styleInformation: styleInformation,
          priority: Priority.max);

      const iosDetails =
          DarwinNotificationDetails(presentAlert: true, presentBadge: true);

      final notificaltionDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificaltionDetails,
          payload: message.data['body']);
    } catch (e) {
      print('=======================chết ở 2');
    }
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('============================User granted permission');
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('============================User granted provisional permission');
      debugPrint('User granted provisional permission');
    } else {
      print(
          '============================User declined or has not accepted permission');
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  Future<String> getReceiverToken(String? receiverId) async {
    final getToken = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    return await getToken.data()!['token'];
  }

  void firebaseNotification(context) {
    try {
      _initLocalNotification();
      FirebaseMessaging.onMessageOpenedApp.listen((event) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NotificationScreen(),
          ),
        );
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print(message.data);
        await _showLocalNotification(message);
      });
    } catch (e) {
      print('===========================chết ở 4');
    }
  }

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String idOther}) async {
    String token = await getReceiverToken(idOther);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$key',
            },
            body: jsonEncode(<String, dynamic>{
              "to": token,
              'priority': 'high',
              'notification': <String, dynamic>{
                'body': body,
                'title': title,
              },
              'data': <String, String>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'senderId': uid,
              }
            }),
          )
          .then((value) =>
              debugPrint('đây là thành công ============ ${value.body}'))
          .onError((error, stackTrace) =>
              debugPrint('đây là thất bại==============${error.toString()}'));
      print('thành công=======================');
    } catch (e) {
      print('Lỗi ==========================');
      debugPrint(e.toString());
    }
  }
}
