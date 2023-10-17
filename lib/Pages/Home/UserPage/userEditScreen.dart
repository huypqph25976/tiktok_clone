import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone2/Services/storageService.dart';
import 'package:tiktok_clone2/Services/userService.dart';
import 'package:tiktok_clone2/Widgets/customText.dart';

class UserEditScreen extends StatelessWidget {
  UserEditScreen({Key? key}) : super(key: key);

  TextEditingController usernameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  final keyUser = GlobalKey<FormState>();

  edit(BuildContext context) {
    bool isValidate = keyUser.currentState!.validate();
    if (isValidate) {
      UserService.editUserFetch(
        context: context,
        phone: phoneController.text,
        username: usernameController.text,
        bio : bioController.text,
      );
    }
  }

  String? validateUsername(String value) {
    if (value == '') {
      return "Empty";
    } else if (value.length >= 50) {
      return "Too long";
    } else {
      return null;
    }
  }

  String? validatePhone(String value) {
    if (value == '') {
      return "Empty";
    } else if (value.length != 10) {
      return "wrong number";
    } else {
      return null;
    }
  }
  String? validateBio(String value) {
    if (value == '') {
      return "Empty";
    } else if (value.length >=50) {
      return "Too long";
    } else {
      return null;
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

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
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
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(
                              snapshot.data?.docs.first['avartarURL']),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: -3,
                    child: IconButton(
                      onPressed: () async {
                        File? fileImage = await getImage();
                        if (fileImage == null) {
                        } else {
                          String fileName =
                              await StorageService.uploadImage(fileImage);
                          UserService.editUserImage(
                              context: context, ImageStorageLink: fileName);
                        }
                      },
                      icon: const Icon(
                        Icons.upload_sharp,
                        color: Colors.pink,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 32,
              child: Form(
                key: keyUser,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Username
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "Username",

                        prefixIcon: Icon(Icons.person, color: Colors.black),

                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {},
                      validator: (value) {
                        return validateUsername(value!);
                      },
                    ),


                    //Phone
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "Phone",

                        prefixIcon: Icon(Icons.phone, color: Colors.black),

                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {},
                      validator: (value) {
                        return validatePhone(value!);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: bioController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "Bio",

                        prefixIcon: Icon(Icons.person, color: Colors.black),

                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {},
                      validator: (value) {
                        return validateBio(value!);
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        edit(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
