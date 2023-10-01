import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/chatScreen.dart';
import 'package:tiktok_clone2/Pages/Home/mainVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/uploadVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/userProfileScreen.dart';
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
    const ChatScreen(),
    const UploadVideoScreen(),
    const MainVideoScreen(),
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
               Icons.person_2_outlined,
               size: 30,
             ),
             label: 'Home'
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
