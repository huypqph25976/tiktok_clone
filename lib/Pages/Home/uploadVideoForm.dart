import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UploadVideoForm extends StatefulWidget {

  final File videofile;
  final String videopath;

   UploadVideoForm(
       {required this.videofile,
       required this.videopath});


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
      playerController = VideoPlayerController.file(widget.videofile);
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

            //hiển thị máy quay
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(playerController!),
            )

          ],
        ),

      ),
    );
  }
}
