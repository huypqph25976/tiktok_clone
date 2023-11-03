import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/Notification/NotificationScreen.dart';
import 'package:tiktok_clone2/Pages/Home/Notification/NotificationService.dart';

import 'package:tiktok_clone2/Pages/Home/Video/mainVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/Video/uploadVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/UserPage/userProfileScreen.dart';
import 'package:tiktok_clone2/Widgets/custombutton.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'chats/chatScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.sendIndex = 0});
  var sendIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List screenIndex = [
    const MainVideoScreen(),
    ChatScreen(),
    const UploadVideoScreen(),
    const NotificationScreen(),
    const UserProfileScreen()
  ];
  final notification = NotificationsService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification.firebaseNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            widget.sendIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white24,
        currentIndex: widget.sendIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 30,
              ),
              label: 'Chat'),
          BottomNavigationBarItem(
            icon: CustomButton(),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 30,
              ),
              label: 'Notification'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
                size: 30,
              ),
              label: 'Profile'),
        ],
      ),
      body: screenIndex[widget.sendIndex],
    );
  }
}
