import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/chats/chat_detail.dart';

class ChatService {
  static getChatID(
      {required BuildContext context,
        required String personID,
        required String currentUserID,
        required String personImage,
        required String personUsername,
      }) {
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    String chatDocID;
    chats
        .where('users', isEqualTo: {personID: null, currentUserID: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          chatDocID = querySnapshot.docs.single.id;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatDetail(
                      personID: personID,
                      personUsername: personUsername,
                      chatID: chatDocID,
                      personImage: personImage,
                      contextBackPage: context,
                    )),
          );
        } else {
          chats.add({
            'users': {currentUserID: null, personID: null}
          }).then((value) {
            chatDocID = value.id;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatDetail(
                        personID: personID,
                        personUsername: personUsername,
                        chatID: chatDocID,
                        personImage: personImage,
                        contextBackPage: context,
                      )),
            );
          });
        }
      },
    )
        .catchError((e) {});
  }

  static Future getUserPeopleChatID({required String currentUserID}) async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    final result = await users.doc(currentUserID).get();
    return result.get('myChatWithPersonID');
  }

  static Future getUserPeopleChat({required String currentUserID}) async {
    List<dynamic> data = await ChatService.getUserPeopleChatID(
        currentUserID: currentUserID.toString());
    List<String>? listPersonChatID = (data).map((e) => e as String).toList();
    FirebaseFirestore.instance
        .collection('users')
        .where('uID', whereIn: listPersonChatID)
        .snapshots();
    return await FirebaseFirestore.instance
        .collection('users')
        .where('uID', whereIn: listPersonChatID)
        .snapshots();
  }
  
}