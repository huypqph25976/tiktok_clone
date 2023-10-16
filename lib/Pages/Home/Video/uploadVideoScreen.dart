import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok_clone2/Pages/Home/Video/uploadVideoForm.dart';
import 'package:get/get.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  getVideoScreen(ImageSource source, BuildContext context) async {
    final videoFile = await ImagePicker().pickVideo(source: source);
    if (videoFile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UploadVideoForm(
            videoFile: File(videoFile.path),
            videoPath: videoFile.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/uploadVideo.png'),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Text(
              "Upload your video",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Text(
            "Choose a way to upload videos",
            style: TextStyle(
                color: Color(0xff777777),
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: ElevatedButton(
              onPressed: () {
                getVideoScreen(ImageSource.camera, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 60, 10),
                    child: Icon(Icons.camera),
                  ),
                  Text(
                    "Record Video",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                getVideoScreen(ImageSource.gallery, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 60, 10),
                    child: Icon(Icons.upload),
                  ),
                  Text(
                    "Upload Video",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
