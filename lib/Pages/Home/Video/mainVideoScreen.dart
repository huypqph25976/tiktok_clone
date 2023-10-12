
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/ProfileTabbar/followingVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/ProfileTabbar/related_videoScreen.dart';

class MainVideoScreen extends StatefulWidget {
  const MainVideoScreen({super.key});

  @override
  State<MainVideoScreen> createState() => _MainVideoScreenState();
}

class _MainVideoScreenState extends State<MainVideoScreen> {

    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text("Related Video", style: TextStyle(fontSize: 20),)),
                  Tab(child: Text("Following Video", style: TextStyle(fontSize: 20),)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                RelatedVideoScreen(),
                const FollowingVideoScreen(),

              ],
            ),

          ),
      );
    }
}















