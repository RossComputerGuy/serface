import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:serface/apps.dart';
import 'package:serface/logic.dart';
import 'package:serface/layouts.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' hide Video;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class SerfaceYouTubeVideoView extends StatefulWidget {
  const SerfaceYouTubeVideoView({ super.key });

  @override
  State<SerfaceYouTubeVideoView> createState() => _SerfaceYouTubeVideoViewState();
}

class _SerfaceYouTubeVideoViewState extends State<SerfaceYouTubeVideoView> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final yt = YoutubeExplode();
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      yt.videos.streamsClient.getManifest((ModalRoute.of(context)!.settings!.arguments! as Map<String, String>)['id']!).then((streamInfo) {
        player.open(Media(streamInfo.muxed.last.url.toString()));
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    yt.close();
    super.dispose();
  }

  Widget build(BuildContext context) =>
    SerfaceMainLayout(
      scaffoldKey: _scaffold,
      child: Video(
        controller: controller,
        controls: (state) =>
          MaterialVideoControlsTheme(
            normal: kDefaultMaterialVideoControlsThemeData.copyWith(
              bottomButtonBar: [
                MaterialPositionIndicator(),
                Spacer(),
              ],
            ),
            fullscreen: kDefaultMaterialVideoControlsThemeDataFullscreen,
            child: MaterialVideoControls(state),
          ),
      ),
    );
}
