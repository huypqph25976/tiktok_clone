import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/showflow/personFollower.dart';
import 'package:tiktok_clone2/Pages/Home/showflow/personFollowing.dart';

class PresonShowFollowScreen extends StatefulWidget {
   PresonShowFollowScreen({super.key
  , required this.OtherID});
  final String OtherID;

  @override
  State<PresonShowFollowScreen> createState() => _PresonShowFollowScreen();
}

class _PresonShowFollowScreen extends State<PresonShowFollowScreen> {




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.black,
          title: const Text('Follow', textAlign: TextAlign.center,),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(child: Text("Following",
                style: TextStyle(fontSize: 20, color: Colors.grey),)),
              Tab(child: Text("Follower",
                style: TextStyle(fontSize: 20, color: Colors.grey),)),
            ],

          ),
        ),
        body: TabBarView(
          children: [
            PersonFollowing(OtherID:widget.OtherID,),
             PersonFollower(personID: widget.OtherID,),
          ],
        ),

      ),
    );
  }
}
