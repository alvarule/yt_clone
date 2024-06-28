import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:yt_clone/widgets/custom_text.dart';

class VideoScreen extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoScreen({super.key, required this.video});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    
    // Initialize the video player controller with the video URL
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video["url"]),
    );

    // Initialize the Chewie controller with various settings
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true, // Video starts playing automatically
      looping: false, // Video does not loop
      aspectRatio: 1.7, // Aspect ratio of the video player
      allowedScreenSleep: false, // Prevent screen from sleeping while video is playing
      allowFullScreen: true, // Allow fullscreen mode
      fullScreenByDefault: false, // Do not start in fullscreen mode by default
      allowPlaybackSpeedChanging: true, // Allow changing playback speed
      allowMuting: true, // Allow muting the video
      showControls: true, // Show playback controls
      showControlsOnInitialize: true, // Show controls when video initializes
      materialProgressColors: ChewieProgressColors(), // Set custom progress bar colors (if needed)
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player widget with aspect ratio
            AspectRatio(
              aspectRatio: 1.7,
              child: Chewie(controller: _chewieController),
            ),
            // Video title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: CustomText(
                text: widget.video["title"],
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).focusColor,
              ),
            ),
            // Video description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomText(
                text: widget.video['description'],
                fontSize: 14,
                color: Theme.of(context).focusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
