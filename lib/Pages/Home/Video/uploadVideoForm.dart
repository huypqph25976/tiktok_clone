import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok_clone2/Services/storageService.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';


class UploadVideoForm extends StatefulWidget {
  final File videoFile;
  final String videoPath;


  const UploadVideoForm(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  @override
  State<UploadVideoForm> createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
  VideoPlayerController? playerController;
  final formKey = GlobalKey<FormState>();
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController captionController = TextEditingController();


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

  void addTextOnVideo(String videoPath, String text) async {
    final String outputPath = '${Directory.systemTemp.path}/output.mp4';

    final String fontPath = '${Directory.systemTemp.path}/OpenSans-Regular.ttf';
    final ByteData fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final File fontFile = File(fontPath);
    await fontFile.writeAsBytes(fontData.buffer.asUint8List(), flush: true);

    final String command = '-i $videoPath -vf "drawtext=fontfile=$fontPath:text=$text:fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2" $outputPath';

    final int rc = (await FFmpegKit.executeAsync(command)) as int;
    if (ReturnCode.isSuccess(rc as ReturnCode?)) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference ref = storage.ref().child('output.mp4');
      await ref.putFile(File(outputPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Upload Video',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 2 / 3,
                height: MediaQuery.of(context).size.height / 1.6,
                child: VideoPlayer(playerController!),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: songNameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          hintText: "Song Name",
                          prefixIcon:
                              Icon(Icons.music_note, color: Colors.black),
                          enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: captionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          hintText: "Caption",
                          prefixIcon:
                              Icon(Icons.text_fields, color: Colors.black),
                          enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đang tải lên video của bạn...'),
                              duration: Duration(minutes: 1),
                            ),
                          );
                          StorageService.uploadVideo(
                              context,
                              songNameController.text,
                              captionController.text,
                              widget.videoPath);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Upload",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
