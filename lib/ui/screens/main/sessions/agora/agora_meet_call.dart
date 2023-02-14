import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/agora_bloc.dart';
import '../../../../../resources/images.dart';

class AgoraMeetScreen extends StatefulWidget {
  const AgoraMeetScreen({super.key});

  static Future open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AgoraMeetScreen(),
      ),
    );
  }

  @override
  _AgoraMeetScreenState createState() => _AgoraMeetScreenState();
}

class _AgoraMeetScreenState extends State<AgoraMeetScreen> {
  String appId = "968ae33c48f744f1bcc1b7f120348c74";
  String token =
      "007eJxTYNg95QCT+6r1q+9aPFhuXP197qLE8IvbZ7YbKB3eoKmZK7BXgcHSzCIx1dg42cQizdzEJM0wKTnZMMk8zdDIwNjEItnchEn1dXJDICPDjo5QJkYGCATx2RlKUotLMvPSGRgA/Z4hHQ==";
  String channel = "testing";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool? isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  late bool audio;
  late bool video;

  AssetImage audioIcon = const AssetImage(Images.mic);
  AssetImage videoIcon = const AssetImage(Images.videoOn);

  initializeSDK() async {
    // Set up an instance of Agora engine
    var callBloc = Provider.of<AgoraBloc>(context, listen: false);

    agoraEngine = await callBloc.setupVideoSDKEngine(
      token: token,
      channel: channel,
    );
    isJoined = true;
    callBloc.join();
    setState(() {});
  }

  @override
  void initState() {
    audio = true;
    video = true;
    super.initState();
    initializeSDK();
  }

  @override
  Widget build(BuildContext context) {
    var callBloc = Provider.of<AgoraBloc>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: isJoined == false
            ? const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              )
            : Stack(
                children: [
                  Center(child: _remoteVideo(isJoined: isJoined!)),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: SizedBox(
                      width: 150,
                      height: 200,
                      child: _localPreview(),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: FloatingActionButton(
                            onPressed: setVideoEnabled,
                            child: ImageIcon(videoIcon, size: 25),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 75,
                          width: 75,
                          child: FloatingActionButton(
                            onPressed: () {
                              ProgressUtils.handleProgress(
                                context,
                                task: () async {
                                  callBloc.leave();
                                  Navigator.pop(context);
                                },
                              );
                            },
                            backgroundColor: Colors.redAccent,
                            child: const Icon(Icons.call_end),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: FloatingActionButton(
                            onPressed: setAudioEnabled,
                            child: ImageIcon(audioIcon, size: 25),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

// Display local video preview
  Widget _localPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: (video)
          ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: agoraEngine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
          : Container(
              color: Colors.black87,
              child: const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

// Display remote user's video
  Widget _remoteVideo({bool isJoined = false}) {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      String msg = '';
      if (isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  setAudioEnabled() async {
    audio = !audio;
    audioIcon = AssetImage((audio) ? Images.mic : Images.micOff);
    (audio)
        ? await agoraEngine.disableAudio()
        : await agoraEngine.enableAudio();
    setState(() {});
  }

  setVideoEnabled() async {
    video = !video;
    videoIcon = AssetImage((video) ? Images.videoOn : Images.videoOff);
    (video)
        ? await agoraEngine.enableVideo()
        : await agoraEngine.disableVideo();
    setState(() {});
  }
}
