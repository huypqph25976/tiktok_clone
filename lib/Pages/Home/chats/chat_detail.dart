import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:tiktok_clone2/Pages/Home/UserPage/PersonInfomation.dart';

import '../../../Providers/loading_model.dart';
import '../../../Providers/save_model.dart';
import '../../../Services/chatService.dart';
import '../../../Services/storageService.dart';
import '../../../Widgets/customText.dart';

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
  final TextEditingController textEditingController = TextEditingController();
  bool showEmoji = false;

  _ChatDetailState(
      this.personID, this.personUsername, this.chatID, this.personImage);

  void sendMessage(String message, String personChatID, String type) {
    if (message == '') return;
    chats.doc(chatID).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': currentUserID,
      'content': message,
      'type': type
    }).then((value) async {
      textEditingController.text = '';

      try {
        List<dynamic> data = await ChatService.getUserPeopleChatID(
            currentUserID: currentUserID.toString());
        List<String>? listPersonID =
        (data).map((e) => e as String).toList();
        if (listPersonID != null) {
          for (int i = 0; i < listPersonID.length; i++) {
            if (personChatID == listPersonID[i]) {
              return;
            }
          }
          final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
          users.doc(currentUserID).update({
            'myChatWithPersonID': FieldValue.arrayUnion([personChatID]),
          });
        }

      } catch (e) {
        final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
        users.doc(currentUserID).update({
          'myChatWithPersonID': FieldValue.arrayUnion([personChatID]),
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

  _onBackspacePressed() {
    textEditingController
      ..text = textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    // context.read<LoadingModel>().isLoading = false;
    // context.read<SaveModel>().isSaving = 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Container(
              height: 50,
              width: 50,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PersonInformation(personID: personID)),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(personImage),
                ),
              ),
            ),

            const SizedBox(
              width: 15,
            ),

            Container(
              child: CustomText(
                alignment: Alignment.center,
                fontsize: 20,
                text: personUsername,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),


          ],
        ),

        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatID)
            .collection('messages')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return const Text('Something went wrong');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            return Column(
              children: [
                Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs.map((DocumentSnapshot document){
                            var data = document.data()! as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            : DateFormat.yMMMd()
                                            .add_jm()
                                            .format(
                                            data['createdOn'].toDate()),
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: data['type'] == 'images'
                                            ? GestureDetector(

                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            padding:
                                            const EdgeInsets.only(
                                                left: 10, right: 10),
                                            alignment: isSender(
                                                data['uID']
                                                    .toString())
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Image.network(
                                              data['content'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                            : BubbleSpecialThree(
                                          text: data['content'],
                                          color: isSender(
                                              data['uID'].toString())
                                              ? Colors.pink
                                              : Colors.black,
                                          tail: true,
                                          isSender: isSender(
                                              data['uID'].toString()),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    ),
                ),
                // Consumer<LoadingModel>(
                //   builder: (_, isLoadingImage, __) {
                //     if (isLoadingImage.isLoading) {
                //       return Container(
                //         width: MediaQuery.of(context).size.width,
                //         color: Colors.white,
                //         child: const CircleAvatar(
                //           backgroundColor: Colors.white,
                //           child: Center(
                //             child: CircularProgressIndicator(),
                //           ),
                //         ),
                //       );
                //     } else {
                //       return Container();
                //     }
                //   },
                // ),

                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () async {
                              File? fileImage = await getImage(ImageSource.camera);
                              String fileName = await StorageService.uploadImageToChat(fileImage);
                              sendMessage(fileName, personID, 'images');
                            }, icon: const Icon(Icons.enhance_photo_translate, color: Colors.black,)),

                        IconButton(
                            onPressed: () async {
                              File? fileImage = await getImage(ImageSource.gallery);
                              String fileName = await StorageService.uploadImageToChat(fileImage);
                              sendMessage(fileName, personID, 'images');
                            }, icon: const Icon(Icons.image_outlined, color: Colors.black)),

                        IconButton(
                            onPressed: () async {
                              setState(() {
                                showEmoji = !showEmoji;
                              });

                            }, icon: const Icon(Icons.emoji_emotions, color: Colors.black)),



                        Expanded(
                          child: Container(
                            height: 45,
                            child: TextField(
                              controller: textEditingController,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                hintText: "Type here ...",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    sendMessage(textEditingController.text,
                                        personID, 'text');

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
                  ),
                ),

                Offstage(
                  offstage: !showEmoji,
                  child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        textEditingController: textEditingController,
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style: TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          loadingIndicator: const SizedBox.shrink(),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                          checkPlatformCompatibility: true,
                        ),
                      )),
                ),
              ],
            );
          }
          return const Center(
            child: Text('Failed!'),
          );
        },
      ),

    );
  }
}
