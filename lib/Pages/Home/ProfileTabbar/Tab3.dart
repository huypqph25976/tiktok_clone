import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Models/Users.dart';
import 'package:tiktok_clone2/Pages/Home/Video/videoProfileScreen.dart';
import 'package:tiktok_clone2/Services/storageService.dart';
import 'package:tiktok_clone2/Services/videoService.dart';
import 'package:tiktok_clone2/Widgets/dialogWidget.dart';

class Tab3 extends StatelessWidget {
  const Tab3({super.key});

  @override
  Widget build(BuildContext context) {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    Offset tapDownPosition = Offset.zero;
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (BuildContext context, snapshot) {

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!['bookmark'].length,
              itemBuilder: (BuildContext context, int index) {
                String videoId = snapshot.data!['bookmark'][index].toString();
                DocumentReference videoRef = FirebaseFirestore.instance
                    .collection('videos')
                    .doc(videoId);

                return FutureBuilder<DocumentSnapshot>(
                  future: videoRef.get(),
                  builder: (context, videoDoc) {
                    if (videoDoc.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (videoDoc.hasError) {
                      return Text('Error: ${videoDoc.error}');
                    } else if (!videoDoc.hasData) {
                      return const Text('No data available');
                    } else {
                      Map<String, dynamic> item =
                          videoDoc.data!.data() as Map<String, dynamic>;
                      print(item['username']);
                      return Card(
                        color: Colors.grey,
                        child: InkWell(

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoProfileScreen(
                                        videoID: item['id'],
                                      )),
                            );
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              ClipRect(
                                child: Image.network(
                                  '${item['thumbnail']}',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${item['likes'].length}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
