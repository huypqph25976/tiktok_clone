import 'package:flutter/material.dart';


import 'Follower.dart';
import 'Following.dart';



class ShowfoloweScreen extends StatefulWidget {
  const ShowfoloweScreen({super.key});

  @override
  State<ShowfoloweScreen> createState() => _ShowfoloweScreenState();
}

class _ShowfoloweScreenState extends State<ShowfoloweScreen> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.white,
          title: const Text('sdssa',textAlign: TextAlign.center,),
          bottom:  TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Text("Following", style: TextStyle(fontSize: 20,color: Colors.grey),)),
              Tab(child: Text("Follower", style: TextStyle(fontSize: 20, color: Colors.grey),)),
            ],

          ),
        ),
        body: TabBarView(
          children: [
            Following(),
            const Follower(),
          ],
        ),

      ),
    );
  }
}
