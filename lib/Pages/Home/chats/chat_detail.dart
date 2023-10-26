import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Providers/loading_model.dart';
import '../../../Providers/save_model.dart';
import '../../../Services/chatService.dart';

class ChatDetail extends StatefulWidget {
  final String personID;
  final String personUsername;
  final String chatID;
  final String personImage;
  final BuildContext? contextBackPage;

  const ChatDetail({
    Key? key,
    required this.personID,
    required this.personUsername,
    required this.personImage,
    required this.chatID,
    this.contextBackPage,
  }) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState(this.personID, this.personUsername, this.chatID, this.personImage);
}

class _ChatDetailState extends State<ChatDetail> {

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final personID;
  final personUsername;
  final personImage;
  final chatID;
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;
  var chatDocID;
  final TextEditingController _textEditingController = TextEditingController();

  _ChatDetailState(
      this.personID, this.personUsername, this.chatID, this.personImage);

  void sendMessage(String message, String peopleChatID, String type) {
    if (message == '') return;
    chats.doc(chatID).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': currentUserID,
      'content': message,
      'type': type
    }).then((value) async {
      _textEditingController.text = '';

      try {
        List<dynamic> data = await ChatService.getUserPeopleChatID(
            currentUserID: currentUserID.toString());
        List<String>? listPersonID =
        (data).map((e) => e as String).toList();
        if (listPersonID != null) {
          for (int i = 0; i < listPersonID.length; i++) {
            if (peopleChatID == listPersonID[i]) {
              return;
            }
          }
          final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
          users.doc(currentUserID).update({
            'myChatWithPersonID': FieldValue.arrayUnion([peopleChatID]),
          });
        }

      } catch (e) {
        final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
        users.doc(currentUserID).update({
          'myChatWithPersonID': FieldValue.arrayUnion([peopleChatID]),
        });
      }
    });
  }

  bool isSender(String sender) {
    return sender == currentUserID;
  }

  Alignment alignment(sender) {
    if (sender == currentUserID) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  Future<File?> getImage(ImageSource src) async {
    var picker = await ImagePicker().pickImage(source: src);
    if (picker != null) {
      File? imageFile = File(picker.path);
      return imageFile;
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {

    context.read<LoadingModel>().isLoading = false;
    context.read<SaveModel>().isSaving = 0.0;

    return const Placeholder();
  }
}
