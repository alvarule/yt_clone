import 'package:flutter/material.dart';
import 'package:yt_clone/screens/video.dart';
import 'package:yt_clone/widgets/custom_text.dart';

class VideoCard extends StatelessWidget {
  final Map<String, dynamic> video;
  const VideoCard({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoScreen(video: video),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.77,
              child: Image.network(
                video["thumbnail"],
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 40, left: 8),
              child: CustomText(
                text: video["title"],
                color: Theme.of(context).focusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
