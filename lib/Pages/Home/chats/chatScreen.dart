import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../Services/chatService.dart';
import '../../../Widgets/customText.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final currentUserID = FirebaseAuth.instance.currentUser?.uid;

  Stream<QuerySnapshot> currentUserStream() async* {
    List<dynamic> data = await ChatService.getUserPeopleChatID(
        currentUserID: currentUserID.toString());
    List<String>? listChatWithPersonID =
    (data).map((e) => e as String).toList();
    if (listChatWithPersonID == null) {
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('uID', isEqualTo: 'udisao')
          .snapshots();
    } else {
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('uID', whereIn: listChatWithPersonID)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 2.1),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.search)
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!['following'].length,
                      itemBuilder: (BuildContext context, int index) {
                        String followingId = snapshot.data!['following'][index].toString();
                        if (snapshot.data!['follower'].contains(followingId)) {
                          DocumentReference followingRef = FirebaseFirestore.instance.collection('users').doc(followingId);
                          return FutureBuilder<DocumentSnapshot>(
                            future: followingRef.get(),
                            builder: (context, followingDoc) {
                              if (followingDoc.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                Map<String, dynamic> item = followingDoc.data!.data() as Map<String, dynamic>;
                                return InkWell(
                                  onTap: () {
                                    ChatService.getChatID(
                                      context: context,
                                      personID: item['uID'],
                                      currentUserID: currentUserID.toString(),
                                      personImage: item['avartarURL'],
                                      personUsername: item['username'],
                                    );
                                  },
                                  child: ListTile(
                                    leading: Container(
                                      width: 48,
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(item['avartarURL']),
                                      ),
                                    ),
                                    title: CustomText(
                                      alignment: Alignment.centerLeft,
                                      fontsize: 16,
                                      text: item['username'],
                                      fontFamily: 'Poppins',
                                      color: Colors.black54,
                                    ),
                                    trailing: Wrap(
                                      spacing: 20,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.chat,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}