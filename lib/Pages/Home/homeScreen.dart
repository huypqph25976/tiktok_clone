import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/Video/NotificationScreen.dart';
import 'package:tiktok_clone2/Pages/Home/chats/chatScreen.dart';
import 'package:tiktok_clone2/Pages/Home/Video/mainVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/Video/uploadVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/UserPage/userProfileScreen.dart';
import 'package:tiktok_clone2/Widgets/custombutton.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {
  var tabIndex = 0;
  List screenIndex = [
    const MainVideoScreen(),
    ChatScreen(),
    const UploadVideoScreen(),
    const NotificationScreen(),
    const UserProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     bottomNavigationBar: BottomNavigationBar(
       onTap: (index){
         setState(() {
           tabIndex = index;
         });
       },
       type: BottomNavigationBarType.fixed,
       backgroundColor: Colors.black,
       selectedItemColor: Colors.white,
       unselectedItemColor: Colors.white24,
       currentIndex: tabIndex,
       items: const [
          BottomNavigationBarItem(
             icon: Icon(
               Icons.home,
               size: 30,
             ),
           label: 'Home'
         ),

         BottomNavigationBarItem(
             icon: Icon(
               Icons.chat,
               size: 30,
             ),
             label: 'Chat'
         ),


          BottomNavigationBarItem(

             icon: CustomButton(),
             label: '',
         ),

         BottomNavigationBarItem(
             icon: Icon(
               Icons.notifications,
               size: 30,
             ),
             label: 'Notification'
         ),

         BottomNavigationBarItem(
             icon: Icon(
               Icons.person_2_outlined,
               size: 30,
             ),
             label: 'Profile'
         ),
       ],
     ),
      body: screenIndex[tabIndex],
    );

  }
}
