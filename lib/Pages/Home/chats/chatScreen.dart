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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('uID', isNotEqualTo: currentUserID)
                  .snapshots(includeMetadataChanges: true),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    final item = snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        ChatService.getChatID(
                            context: context,
                            personID: item['uID'],
                            currentUserID: currentUserID.toString(),
                            personImage: item['avartarURL'],
                            personUsername: item['username']);
                      },
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              item['avartarURL'],
                            ),
                          ),
                        ),
                        title: CustomText(
                          alignment: Alignment.centerLeft,
                          fontsize: 16,
                          text: item['username'],
                          fontFamily: 'Poppins',
                          color: Colors.black54,
                        ),
                        // subtitle: CustomText(
                        //   alignment: Alignment.centerLeft,
                        //   fontsize: 16,
                        //   text:  'Last Active : ${timeago.format(item['uID'].lastActive)}',
                        // ),
                        trailing: Wrap(spacing: 20, children: [
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.chat,
                              color: Colors.grey,
                            ),
                          )
                        ]),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
