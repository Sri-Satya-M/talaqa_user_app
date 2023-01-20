import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideoScreen extends StatefulWidget {
  final String link;

  const PlayVideoScreen({super.key, required this.link});

  static Future open(BuildContext context, {required String link}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayVideoScreen(link: link),
      ),
    );
  }

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.link).toString(),
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
            Navigator.pop(context);
          },
          onEnterFullScreen: () {},
          player: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: controller,
          ),
          builder: (context, player) => player,
        ),
      ),
    );
  }
}
