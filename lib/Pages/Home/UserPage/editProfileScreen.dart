import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone2/Services/storageService.dart';
import 'package:tiktok_clone2/Services/userService.dart';
import 'package:tiktok_clone2/Widgets/textInput.dart';

class EditProfileScreen extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  const EditProfileScreen({super.key, required this.snapshot});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();

  doEdit(BuildContext context) {
    UserService.editUserFetch(
      context: context,
      phone: phone.text,
      username: username.text,
      bio: bio.text,
    );
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

  @override
  void initState() {
    super.initState();
    var userData = widget.snapshot.data;
    username.text = userData['username'] ?? '';
    email.text = userData['email'] ?? '';
    phone.text = userData['phone'] ?? '';
    bio.text = userData['bio'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.snapshot.data;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: const Text(
            'Edit profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment
                        .bottomRight, // Đặt nút "edit" ở góc trên bên phải
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          userData['avartarURL'],
                          // 'images/tik-tok.png',
                          height: 100,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 50,
                            left:
                                20), // Điều chỉnh khoảng cách từ góc trên bên phải
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.blue,
                        ),
                        child: InkWell(
                          onTap: () async {
                            File? fileImage = await getImage();
                            if (fileImage == null) {
                            } else {
                              String fileName =
                                  await StorageService.uploadImage(fileImage);
                              UserService.editUserImage(
                                  context: context, ImageStorageLink: fileName);
                            }
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Giới thiệu về bản thân',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: TextInputWidget(
                        textEditingController: username,
                        iconData: Icons.near_me,
                        lableString: "Full name",
                        isObscure: false),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: TextInputWidget(
                        textEditingController: email,
                        iconData: Icons.email,
                        lableString: "Email",
                        isObscure: false),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: TextInputWidget(
                        textEditingController: phone,
                        iconData: Icons.phone,
                        lableString: "Phone",
                        isObscure: false),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: TextInputWidget(
                        textEditingController: bio,
                        iconData: Icons.biotech,
                        lableString: "Bio",
                        isObscure: false),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.25,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.25,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () {
                              doEdit(context);
                            },
                            child: const Text('Edit')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
    ;
  }
}
