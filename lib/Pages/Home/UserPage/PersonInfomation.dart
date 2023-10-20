import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone2/Pages/Home/PersonTabbar/PersonTab1.dart';
import 'package:tiktok_clone2/Pages/Home/PersonTabbar/PersonTab2.dart';

import '../../../Services/userService.dart';
import '../Video/uploadVideoForm.dart';
import 'changePasswordScreen.dart';

class PersonInformation extends StatefulWidget {
  const PersonInformation({Key? key, required this.personID}) : super(key: key);

  final String personID;

  @override
  State<PersonInformation> createState() => _PersonInformationState();
}

class _PersonInformationState extends State<PersonInformation> with TickerProviderStateMixin {

  late TabController tabController;
  String? uid = FirebaseAuth.instance.currentUser?.uid;


  Future<File?> getImage() async {
    var picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker != null) {
      File? imageFile = File(picker.path);
      return imageFile;
    }
    return null;
  }

  Stream<QuerySnapshot> getUserImage() async* {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uID', isEqualTo: currentUserID)
        .snapshots();
  }

  Stream<QuerySnapshot> getPeopleImage(String id) async* {
    yield* FirebaseFirestore.instance
        .collection('users')
        .where('uID', isEqualTo: id)
        .snapshots();
  }

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadVideoForm(
            videoFile: File(video.path),
            videoPath: video.path,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      body: StreamBuilder(
          stream: UserService.getPerson(widget.personID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //
                      // IconButton(
                      //   onPressed: () {
                      //     ChatService.getChatID(
                      //       context: context,
                      //       peopleID: snapshot.data.get('uID'),
                      //       currentUserID: '$uid',
                      //       peopleName: snapshot.data.get('fullName'),
                      //       peopleImage: snapshot.data.get('avartaURL'),
                      //     );
                      //   },
                      //   iconSize: 25,
                      //   icon:  Icon(
                      //     CupertinoIcons.chat_bubble_fill,
                      //     color: Colors.black87,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: getPeopleImage(widget.personID),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("error");
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: NetworkImage(
                                    snapshot.data?.docs.first['avartarURL']),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${snapshot.data.get('username')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.pink,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            snapshot.data.get('following').length.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          Text(
                            "Followed",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            snapshot.data.get('follower').length.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          Text(
                            "Follower",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          UserService.follow(widget.personID);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 60),),
                            child:  !snapshot.data.get('follower').contains(uid) ?

                             const Text(
                                "Follow",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white, ),
                              ) :
                            const Icon(Icons.person_3),

                          ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Nhắn tin ",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),



                  Container(
                    child: TabBar(
                      indicatorColor: Colors.black,
                      controller: tabController,
                      tabs: const [
                        Tab(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.video_collection,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                   Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(
                      controller: tabController,
                      children:  [
                        PersonTab1(personID: widget.personID),
                        PersonTab2(personID: widget.personID),

                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
