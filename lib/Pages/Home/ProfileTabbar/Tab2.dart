import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/Video/videoProfileScreen.dart';
import 'package:tiktok_clone2/Services/storageService.dart';
import 'package:tiktok_clone2/Widgets/dialogWidget.dart';

class Tab2 extends StatelessWidget {
  const Tab2({super.key});

  @override
  Widget build(BuildContext context) {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    Offset tapDownPosition = Offset.zero;
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
        body: SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  mainAxisSpacing: 10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data!.docs[index];
                return Card(
                  color: Colors.grey,
                  child: InkWell(
                    onLongPress: () {
                      showMenu(
                          context: context,
                          position: RelativeRect.fromRect(
                              Rect.fromLTWH(tapDownPosition.dx,
                                  tapDownPosition.dy, 30, 30),
                              Rect.fromLTWH(
                                  0,
                                  0,
                                  overlay!.paintBounds.size.width,
                                  overlay.paintBounds.size.height)),
                          items: [
                            const PopupMenuItem(
                              value: 'bookmark',
                              child: Text('Add To Bookmark'),

                            ),
                            const PopupMenuItem(
                              value: 'pin',
                              child: Text('Pin on top'),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit your video'),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    print(item['thumbnail']);
                                    return DialogWidget(
                                      label: 'Delete video',
                                      content: 'You need delete this video?',
                                      onPressed: () {
                                        StorageService.deleteVideo(
                                            context,
                                            item['id'],
                                            item['videoUrl'],
                                            item['thumbnail']);

                                      },
                                    );
                                  },
                                );
                              },
                              value: 'delete',
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ]);
                    },
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
              });
        },
      ),
    ));
  }
}
