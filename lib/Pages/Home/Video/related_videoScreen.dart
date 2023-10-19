import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone2/Pages/Home/UserPage/PersonInfomation.dart';

import '../../../Models/Video.dart';
import '../../../Services/userService.dart';
import '../../../Services/videoService.dart';
import '../../../Widgets/videoItem.dart';

class RelatedVideoScreen extends StatelessWidget {
  RelatedVideoScreen({super.key});

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference videos = FirebaseFirestore.instance.collection('videos');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> list = [''];

  Stream<QuerySnapshot> fetch() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<dynamic> list2 = snapshot.data()!['following'];
      QuerySnapshot videoSnapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('uid', whereIn: list2)
          .get();
      return videoSnapshot;
    });
  }



  buildProfile(
      BuildContext context, String profilePhoto, String id, String videoUid) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
          children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonInformation(personID: id)),
                  );
                },
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        StreamBuilder(
            stream: users.doc(uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              bool isFollowing = snapshot.data!.get('following').contains(videoUid);
              return Positioned(
                left: 20,
                bottom: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: InkWell(
                    onTap: () async {
                      if (!isFollowing) {
                        await UserService.follow(
                            videoUid); // Function to follow a user
                      }
                    },
                    child: Container(
                      key: ValueKey<int>(isFollowing ? 1 : 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFollowing ? Colors.white : Colors.pink,
                      ),
                      child: Icon(
                        isFollowing ? Icons.check : Icons.add,
                        color: isFollowing ? Colors.pink : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            })
      ]),
    );
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();


  }


  showCommentBottomDialog(BuildContext context, String videoID) {
    final TextEditingController textEditingController = TextEditingController();
    final RenderObject? overlay = Overlay.of(context)?.context.findRenderObject();
    Offset _tapDownPosition = Offset.zero;

    final page2 = SizedBox(
      height: MediaQuery.of(context).size.height * 3 / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                videos.doc(videoID).collection('commentList').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data!.docs.length} Comments',
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: videos.doc(videoID).collection('commentList').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(),
                  );
                }
                //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = snapshot.data!.docs[index];
                            return GestureDetector(

                              onTapDown: (TapDownDetails details){
                                _tapDownPosition = details.globalPosition;
                              },

                              onLongPress: (){
                                showMenu(context: context,
                                    position: RelativeRect.fromRect(
                                        Rect.fromLTWH(_tapDownPosition.dx, _tapDownPosition.dy, 30, 30),
                                        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                                            overlay.paintBounds.size.height)),
                                    items: [
                                      const PopupMenuItem(
                                        value: 'favorites',
                                        child: Text('Add To Favorites'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'comment',
                                        child: Text('Write Comment'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'hide',
                                        child: Text('Hide'),
                                      ),
                                    ]);
                              },
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              '${item['avartarURL']}'),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item['username']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black38),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  3 /
                                                  4,
                                              child: Text(
                                                '${item['content']}',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontFamily: 'Popins'),
                                              ),
                                            ),
                                            Text(
                                              item['createdOn'] == null
                                                  ? DateTime.now().toString()
                                                  : DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(item['createdOn']
                                                  .toDate()),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black38),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(right: 8.0),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  VideoService.likeComment(
                                                      videoID, item['id']);
                                                },
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: snapshot.data!
                                                      .docs[index]['likes']
                                                      .contains(uid)
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                              ),
                                              Text('${item['likes'].length}'),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );


                          },
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: textEditingController,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Comment here ...",
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendComment(textEditingController.text, videoID);
                      textEditingController.text = '';
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //_scaffoldKey.currentState.showBottomSheet((context) => null);
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(7),
        ),
      ),
      //enableDrag: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return page2;
      },
    );
  }

  Future<void> sendComment(String message, String videoID) async {
    if (message == '') return;
    final result = await users.doc(uid).get();
    final String avartarURL = result.get('avartarURL');
    final String username = result.get('username');
    var allDocs = await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoID)
        .collection('commentList')
        .get();
    int len = allDocs.docs.length;
    videos.doc(videoID).collection('commentList').doc('Comment $len').set({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': uid,
      'content': message,
      'avartarURL': avartarURL,
      'username': username,
      'id': 'Comment $len',
      'likes': []
    }).then((value) async {});
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

        return SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('videos').where('uid', whereNotIn: [uid]).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text("Some thing wrong?");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                  return PageView.builder(
                    itemCount: snapshot.data!.docs.length,
                    controller: PageController(initialPage: 0, viewportFraction: 1),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {

                      final Video item = Video.fromSnap(snapshot.data!.docs[index]);
                      return Stack(
                        children: [
                          VideoItems(
                            videoUrl: item.videoUrl,
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child:  Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // InkWell(
                                            //   onTap: (){
                                            //
                                            //     Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //         builder: (context) => PersonInformation(personID: id)),
                                            //   },
                                            //   child:
                                          Text(
                                              '@ ${item.username}',
                                              style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              ),
                                              ),


                                            Text(
                                              item.songName,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                             Row(
                                              children: [
                                                const Icon(
                                                  Icons.music_note,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  item.caption,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(top: size.height / 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          buildProfile(context, item.profilePhoto, item.uid, item.uid),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {VideoService.likeVideo(item.id);},
                                                child:  Icon(
                                                  Icons.favorite,
                                                  size: 40,
                                                  color: snapshot.data!.docs[index]['likes'].contains(uid)
                                                      ? Colors.red : Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 7),
                                               Text(
                                                 '${item.likes.length}',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),



                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {showCommentBottomDialog(context, item.id);},
                                                child: const Icon(
                                                  Icons.comment,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              ),

                                              const SizedBox(height: 7),

                                              StreamBuilder<QuerySnapshot>(
                                                stream: videos
                                                    .doc(item.id)
                                                    .collection('commentList')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                                  if (snapshot.hasError) {
                                                    return const Text(
                                                        'Something went wrong');
                                                  }
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                      '${snapshot.data!.docs.length}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              ),

                                            ],
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: const Icon(
                                                  Icons.reply,
                                                  size: 40,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              const SizedBox(height: 7),

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );

              }),
        );
  }
}
