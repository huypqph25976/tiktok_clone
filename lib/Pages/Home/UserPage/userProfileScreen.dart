import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone2/Pages/Home/ProfileTabbar/Tab1.dart';
import 'package:tiktok_clone2/Pages/Home/ProfileTabbar/Tab2.dart';
import 'package:tiktok_clone2/Pages/Home/UserPage/userEditScreen.dart';
import 'package:tiktok_clone2/Pages/Home/Video/uploadVideoForm.dart';
import 'package:tiktok_clone2/Services/authServices.dart';
import 'package:tiktok_clone2/Services/userService.dart';

import '../ProfileTabbar/Tab3.dart';
import '../showflow/Showflowscreen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with TickerProviderStateMixin {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  getVideoScreen(ImageSource source, BuildContext context) async {
    final videoFile = await ImagePicker().pickVideo(source: source);
    if (videoFile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadVideoForm(
            videoFile: File(videoFile.path),
            videoPath: videoFile.path,
          ),
        ),
      );
    }
  }

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

  showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(30),
        children: [
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 25, color: Colors.red),
                ),
                Text(
                  'Are you sure about that?',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  AuthService.Logout(context: context);
                },
                child: const Row(
                  children:  [
                    Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Yes',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: const Row(
                  children:  [
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'No',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: FutureBuilder(
          future: UserService.getUserInfo(),
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
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      const SizedBox(width: 150,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 90,),

                            ElevatedButton(

                              onPressed: () {
                                showLogoutDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),


                      ),


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
                            stream: getUserImage(),
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
                      color: Color(0xff555555),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),

                         InkWell(
                           onTap: (){
                             Navigator.push(context,  MaterialPageRoute(
                                 builder: (context) => ShowfoloweScreen()));

                           },
                           child:  Text(

                             snapshot.data.get('following').length.toString(),
                             style: const TextStyle(
                                 color: Colors.black,
                                 fontWeight: FontWeight.w500,
                                 fontSize: 20),

                           ),
                         ),

                          InkWell(
                            onTap: (){
                              Navigator.push(context,  MaterialPageRoute(
                                  builder: (context) => ShowfoloweScreen()));
                            },
                            child:
                              Text(
                                "Following",
                                style: TextStyle(color: Colors.grey, fontSize: 12),

                            ),
                          )

                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context,  MaterialPageRoute(
                                  builder: (context) => ShowfoloweScreen()));
                            },
                            child:
                            Text(
                              snapshot.data.get('follower').length.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context,  MaterialPageRoute(
                                  builder: (context) => ShowfoloweScreen()));
                            },
                            child:
                            Text(
                              "Followed",
                              style: TextStyle
                                (color: Colors.grey, fontSize: 12),
                            ),
                            ),

                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            snapshot.data.get('follower').length.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          Text(
                            "Like",
                            style: TextStyle
                              (color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),




                  SizedBox(height: 15),




                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserEditScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                "Setting Profile",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black,fontWeight: FontWeight.normal),

                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),

                      ElevatedButton(

                        onPressed: () {
                          getVideoScreen(ImageSource.gallery, context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                        ),

                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              )

                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(

                        onPressed: () {
                          showLogoutDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),


                  Text(
                    snapshot.data.get('bio'),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17),
                  ),

                  Container(
                    child: TabBar(
                      indicatorColor: Colors.black,
                      controller: tabController,
                      tabs: const [
                        Tab(
                          icon: Icon(
                            Icons.video_collection,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.save,
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
                      children: const [
                        Tab2(),
                        Tab1(),
                        Tab3(),

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
