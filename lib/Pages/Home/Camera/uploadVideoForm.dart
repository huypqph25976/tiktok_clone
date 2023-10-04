import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UploadVideoForm extends StatefulWidget {

  final File videoFile;
  final String videoPath;

  const UploadVideoForm(
       { Key? key, required this.videoFile,
       required this.videoPath}) : super(key: key);


  @override
  State<UploadVideoForm> createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
  VideoPlayerController? playerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      playerController = VideoPlayerController.file(widget.videoFile);
    });

    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(2);
    playerController!.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              child: VideoPlayer(playerController!)


            )

          ],
        ),

      ),
    );
  }
}