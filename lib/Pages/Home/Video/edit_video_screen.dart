import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

class EditVideo extends StatefulWidget {
  final File file;
  const EditVideo(this.file, {super.key});

  @override
  State<EditVideo> createState() => _EditVideoState();


}

class _EditVideoState extends State<EditVideo> {

  final Trimmer trimmer = Trimmer();

  double startValue = 0.0;
  double endValue = 0.0;

  bool isPlaying = false;
  bool progressVisibility = false;

  void loadVideo() {
    trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    trimmer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: progressVisibility
                ? null
                : () async {
              setState(() {
                progressVisibility = true;
              });

              await trimmer.saveTrimmedVideo(
                  startValue: startValue,
                  endValue: endValue,
                  onSave: (String? outputPath) async {
                    Navigator.pop(context, outputPath);
                  });
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: VideoViewer(trimmer: trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    // maxVideoLength: const Duration(seconds: 10),
                    onChangeStart: (value) => startValue = value,
                    onChangeEnd: (value) => endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => isPlaying = value),
                  ),
                ),
                TextButton(
                  child: isPlaying
                      ? const Icon(
                    Icons.pause,
                    size: 80.0,
                    color: Colors.white,
                  )
                      : const Icon(
                    Icons.play_arrow,
                    size: 80.0,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    bool playbackState = await trimmer.videoPlaybackControl(
                      startValue: startValue,
                      endValue: endValue,
                    );
                    setState(() {
                      isPlaying = playbackState;
                    });
                  },
                ),
                Visibility(
                  visible: progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

