import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with your video
    _controller = VideoPlayerController.asset(
      'assets/videos/treevideo.mp4', // Put your video in assets folder
    )..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {});
        // Start playing the video
        _controller.play();
        // Set video to loop
        _controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? SizedBox(
              width: 300, // Same width as your original image
              height: 300, // Same height as your original image
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
