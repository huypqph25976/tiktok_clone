import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone2/Pages/Home/SearchScreen/SearchScreen.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.black),
                      child: Stack(
                        children: [
                          const TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorPadding: EdgeInsets.only(right: 30),
                            labelPadding: EdgeInsets.only(right: 50),
                            tabs: [
                              Tab(
                                child: SizedBox(
                                  width: 60,
                                  child: Text('Related'),
                                ),
                              ),
                              Tab(
                                child: SizedBox(
                                  width: 120,
                                  child: Text('Following'),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 10,
                            top: 0,
                            bottom: 0,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchScreen()),
                                );
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
