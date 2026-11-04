import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:video_player/video_player.dart';

class DriveVideoPlayer extends StatefulWidget {
  final String url;

  const DriveVideoPlayer({super.key, required this.url});

  @override
  State<DriveVideoPlayer> createState() => _DriveVideoPlayerState();
}

class _DriveVideoPlayerState extends State<DriveVideoPlayer> {
  late FlickManager _flickManager;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();

    // Extract File ID from Google Drive URL
    String? fileId = extractGoogleDriveFileId(widget.url);
    if (fileId == null) {
      debugPrint("Invalid Google Drive URL");
      return;
    }
    // Correct direct download link
    String directUrl = "https://drive.google.com/uc?export=download&id=$fileId";

    // Initialize FlickManager with the video URL
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(directUrl),
      autoPlay: true, // Auto-play the video
      autoInitialize: true, // Automatically initialize the video
    );

    // Set initial volume
    _flickManager.flickControlManager?.setVolume(isMuted ? 0.0 : 1.0);
  }

  @override
  void dispose() {
    _flickManager.dispose(); // Dispose FlickManager
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Video Player
            Container(
              height: 400.0, // Increased fixed height for better visibility
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FlickVideoPlayer(
                  flickManager: _flickManager,
                  flickVideoWithControls: FlickVideoWithControls(
                    iconThemeData: IconThemeData(
                      color: AppColors.primaryColor, // Change icon color
                    ),
                    controls: FlickPortraitControls(
                      // : Colors.blue, // Change icon color
                      progressBarSettings: FlickProgressBarSettings(
                        playedColor: AppColors
                            .primaryColor, // Change progress bar played color
                        handleColor: AppColors
                            .primaryColor, // Change progress bar handle color
                        backgroundColor: const Color.fromARGB(255, 164, 164,
                            164), // Change progress bar background color
                        bufferedColor: const Color.fromARGB(
                            255, 219, 219, 219), // Change buffered color
                      ),
                    ),
                    textStyle: TextStyle(
                      color: AppColors.primaryColor, // Change timer text color
                      fontSize: 12, // Optional: Adjust font size
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to extract File ID from Google Drive URL
  String? extractGoogleDriveFileId(String url) {
    RegExp regExp = RegExp(r"/d/([a-zA-Z0-9_-]+)");
    var match = regExp.firstMatch(url);
    return match?.group(1);
  }
}
