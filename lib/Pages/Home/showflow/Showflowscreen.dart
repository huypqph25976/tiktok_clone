import 'package:flutter/material.dart';


import 'Follower.dart';
import 'Following.dart';



class ShowfoloweScreen extends StatefulWidget {
  const ShowfoloweScreen({super.key});

  @override
  State<ShowfoloweScreen> createState() => _ShowfoloweScreenState();
}

class _ShowfoloweScreenState extends State<ShowfoloweScreen> {
  var tabIndex = 0;
  List screenIndex = [
    Follower(),
    Follower(),
    const Following()
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
              label: 'Follower'
          ),

          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 30,
              ),
              label: 'Following'
          ),
        ],
      ),
      body: screenIndex[tabIndex],
    );

  }
}
