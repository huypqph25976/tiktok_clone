import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final String videoUrl;
  const VideoItems({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoItems> createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  late VideoPlayerController videoPlayerController;
  bool isPlaying = true;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)..initialize().then((value) {
        videoPlayerController.play();
        isPlaying = true;
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
        // videoPlayerController.pause();
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  videoCtrl() {
    if (isPlaying) {
      setState(() {
        isPlaying = false;
        videoPlayerController.pause();
      });
    } else {
      setState(() {
        isPlaying = true;
        videoPlayerController.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: InkWell(
        onTap: () => {videoCtrl()},
        child: Stack(
          children: [
            VideoPlayer(videoPlayerController),
            isPlaying
                ? const Text('')
                : const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white54,
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
