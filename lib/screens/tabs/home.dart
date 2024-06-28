import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yt_clone/widgets/custom_text.dart';
import 'package:yt_clone/widgets/video_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from("videos")
                  .stream(primaryKey: ["created_at"]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: CustomText(
                      text: "Something went wrong!",
                      fontSize: 16,
                      color: Theme.of(context).focusColor,
                    ),
                  );
                } else {
                  final videos = snapshot.data;
                  if (videos!.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: "No Videos Found!",
                        fontSize: 16,
                        color: Theme.of(context).focusColor,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: videos.length,
                      itemBuilder: (context, index) =>
                          VideoCard(video: videos[index]),
                    );
                  }
                }
              }),
        ),
      ],
    );
  }
}
