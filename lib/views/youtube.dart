import 'package:dynamic_layouts/dynamic_layouts.dart';
import 'package:flutter/material.dart';
import 'package:serface/apps.dart';
import 'package:serface/logic.dart';
import 'package:serface/layouts.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SerfaceYouTubeView extends StatefulWidget {
  const SerfaceYouTubeView({ super.key });

  @override
  State<SerfaceYouTubeView> createState() => _SerfaceYouTubeViewState();
}

class _SerfaceYouTubeViewState extends State<SerfaceYouTubeView> {
  final yt = YoutubeExplode();

  @override
  void dispose() {
    yt.close();
    super.dispose();
  }

  Widget build(BuildContext context) =>
    SerfaceMainLayout(
      child: DynamicGridView.staggered(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: kChannelIds
          .map((id) => FutureBuilder(
            future: yt.channels.get(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextButton(
                  child: Column(
                    children: [
                      Image.network(snapshot.data!.logoUrl),
                      Text(
                        snapshot.data!.title,
                        style: Theme.of(context).textTheme.displayMedium!
                          .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () =>
                    Navigator.pushNamed(context, '/youtube/channel', arguments: {
                      'id': id,
                    }),
                );
              }
              return const SizedBox();
            },
          )).toList(),
      ),
    );
}
