
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/Video/followingVideoScreen.dart';
import 'package:tiktok_clone2/Pages/Home/Video/related_videoScreen.dart';

class MainVideoScreen extends StatefulWidget {
  const MainVideoScreen({super.key});

  @override
  State<MainVideoScreen> createState() => _MainVideoScreenState();
}

class _MainVideoScreenState extends State<MainVideoScreen> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(child: Text('Related', style: TextStyle(fontSize: 20),),),
                          Tab(child: Text('Following', style: TextStyle(fontSize: 20),),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          RelatedVideoScreen(),
                          FollowingVideoScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
}















