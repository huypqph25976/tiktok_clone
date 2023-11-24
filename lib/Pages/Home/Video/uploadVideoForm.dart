import 'dart:io';


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone2/Pages/Home/Video/edit_video_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:tiktok_clone2/Services/storageService.dart';



class UploadVideoForm extends StatefulWidget {
  final XFile videoFile;
  final String videoPath;


  const UploadVideoForm(this.videoFile, this.videoPath,
      {Key? key})
      : super(key: key);

  @override
  State<UploadVideoForm> createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
  late XFile file;
  VideoPlayerController? playerController;
  final formKey = GlobalKey<FormState>();
  final TextEditingController songNameController = TextEditingController();
  final TextEditingController captionController = TextEditingController();


  @override
  void initState() {
    file = widget.videoFile;
    // TODO: implement initState
    playerController = VideoPlayerController.file(File(file.path));
    super.initState();

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

              Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: () async {
                    playerController?.pause();
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditVideo(File(file.path)),
                        ));
                    if (result != null) {
                      print('đã vào đây $result');
                      playerController =
                          VideoPlayerController.file(File(result));
                      playerController?.play();
                      playerController?.initialize().then((value) => {
                        if (mounted)
                          {
                            setState(() {
                              file = XFile(result);
                            })
                            // Kích hoạt lại build để hiển thị video
                          }
                      });
                    }

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black),
                  child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Cut Video",
                        style:
                        TextStyle(fontSize: 15, color: Colors.white),
                      )),
                ),
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
