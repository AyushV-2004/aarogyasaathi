import 'package:flutter/material.dart';
import 'package:aarogyasaathi/authentication/loginpage.dart'; // Ensure the import path is correct
import 'package:video_player/video_player.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  _IntroVideoScreenState createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller
    _videoController = VideoPlayerController.asset('assets/intro_video.mp4') // Ensure you have the correct path to your video file
      ..initialize().then((_) {
        // Start playing the video after it's initialized
        setState(() {}); // Ensure the UI is updated after initialization
        _videoController.play();
      });

    // Listen for when the video ends
    _videoController.addListener(() {
      if (_videoController.value.position == _videoController.value.duration) {
        // Navigate to the login screen after the video ends
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MYLoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videoController.value.isInitialized
            ? FittedBox(
          fit: BoxFit.cover, // Ensures the video fits the screen
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        )
            : const CircularProgressIndicator(), // Show a loading indicator while the video is loading
      ),
    );
  }
}
