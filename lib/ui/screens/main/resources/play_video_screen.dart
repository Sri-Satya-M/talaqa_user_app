import 'package:alsan_app/model/resources.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideoScreen extends StatefulWidget {
  final Resources resource;

  const PlayVideoScreen({super.key, required this.resource});

  static Future open(BuildContext context, {required Resources resource}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayVideoScreen(resource: resource),
      ),
    );
  }

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  late YoutubePlayerController youtubeController;
  bool isFullScreen = false;

  @override
  void initState() {
    youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        widget.resource.link!,
      ).toString(),
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: (isFullScreen)
            ? null
            : AppBar(
                title: Text(
                  widget.resource.title!,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: youtubeController,
          ),
          onEnterFullScreen: () {
            isFullScreen = true;
            setState(() {});
          },
          onExitFullScreen: () {
            isFullScreen = false;
            setState(() {});
          },
          builder: (context, player) => player,
        ),
      ),
    );
  }

  @override
  void dispose() {
    youtubeController.dispose();
    super.dispose();
  }
}
