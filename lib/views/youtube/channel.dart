import 'package:dynamic_layouts/dynamic_layouts.dart';
import 'package:flutter/material.dart';
import 'package:serface/apps.dart';
import 'package:serface/logic.dart';
import 'package:serface/layouts.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SerfaceYouTubeChannelView extends StatefulWidget {
  const SerfaceYouTubeChannelView({ super.key });

  @override
  State<SerfaceYouTubeChannelView> createState() => _SerfaceYouTubeChannelViewState();
}

class _SerfaceYouTubeChannelViewState extends State<SerfaceYouTubeChannelView> {
  final yt = YoutubeExplode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    yt.close();
    super.dispose();
  }

  Widget build(BuildContext context) =>
    SerfaceMainLayout(
      child: FutureBuilder(
        future: yt.channels.getUploadsFromPage((ModalRoute.of(context)!.settings!.arguments! as Map<String, String>)['id']!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DynamicGridView.staggered(
              maxCrossAxisExtent: 500,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: snapshot.data!
                .map((video) =>
                  TextButton(
                    onPressed: () =>
                      Navigator.pushNamed(context, '/youtube/video', arguments: {
                        'id': video.id.value,
                      }),
                    child: Column(
                      children: [
                        Image.network(video.thumbnails.highResUrl),
                        Text(
                          video.title,
                          style: Theme.of(context).textTheme.displayMedium!
                            .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  )).toList(),
            );
          }
          return const SizedBox();
        },
      ),
    );
}
