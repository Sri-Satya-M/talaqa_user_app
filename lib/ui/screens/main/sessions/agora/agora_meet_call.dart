import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/model/clinicians.dart';
import 'package:alsan_app/model/profile.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/remote_user_preview.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/user_preview.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/agora_bloc.dart';
import '../../../../../resources/images.dart';

class AgoraMeetScreen extends StatefulWidget {
  final String token;
  final String channelName;
  final int? uid;
  final Profile patientProfile;
  final Clinician clinician;

  const AgoraMeetScreen({
    super.key,
    required this.token,
    required this.channelName,
    this.uid,
    required this.patientProfile,
    required this.clinician,
  });

  static Future open(BuildContext context,
      {required String token,
      required String channelName,
      required int uid,
      required Profile patientProfile,
      required Clinician clinician}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgoraMeetScreen(
          token: token,
          channelName: channelName,
          uid: uid,
          patientProfile: patientProfile,
          clinician: clinician,
        ),
      ),
    );
  }

  @override
  _AgoraMeetScreenState createState() => _AgoraMeetScreenState();
}

class _AgoraMeetScreenState extends State<AgoraMeetScreen> {
  String appId = "968ae33c48f744f1bcc1b7f120348c74";

  int? _remoteUid; // uid of the remote user
  bool? isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  bool audio = true;
  bool video = false;
  bool volume = false;

  AssetImage audioIcon = const AssetImage(Images.mic);
  AssetImage videoIcon = const AssetImage(Images.videoOff);
  Icon volumeIcon = const Icon(Icons.volume_down_outlined);

  initializeSDK() async {
    // Set up an instance of Agora engine
    var callBloc = Provider.of<AgoraBloc>(context, listen: false);

    agoraEngine = await callBloc.setupVideoSDKEngine(
      token: widget.token,
      channel: widget.channelName,
    );
    isJoined = true;
    callBloc.join();
    setState(() {});
  }

  @override
  void initState() {
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
                  Center(
                    child: RemoteUserPreview(
                      isJoined: isJoined!,
                      agoraEngine: agoraEngine,
                      remoteUid: _remoteUid,
                      channelName: widget.channelName,
                      userName: "Dr. ${widget.clinician.user!.fullName!}",
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: SizedBox(
                      width: 150,
                      height: 200,
                      child: UserPreview(
                        isVideo: video,
                        agoraEngine: agoraEngine,
                        username: widget.patientProfile.fullName!,
                        imageUrl: widget.patientProfile.image,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
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
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            const SizedBox(width: 24),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                onPressed: setAudioEnabled,
                                child: ImageIcon(audioIcon, size: 25),
                              ),
                            ),
                            const SizedBox(width: 24),
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: FloatingActionButton(
                                onPressed: setSpeakerPhone,
                                child: volumeIcon,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  setAudioEnabled() async {
    audio = !audio;
    audioIcon = AssetImage((audio) ? Images.mic : Images.micOff);
    // (audio)
    //     ? await agoraEngine.disableAudio()
    //     : await agoraEngine.enableAudio();
    await agoraEngine.muteLocalAudioStream(!audio);
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

  setSpeakerPhone() async {
    volume = !volume;

    await agoraEngine.setEnableSpeakerphone(volume);
    await agoraEngine.muteLocalAudioStream(volume);

    volumeIcon = Icon(
      (volume) ? Icons.volume_up_outlined : Icons.volume_down_outlined,
    );
    setState(() {});
  }

  @override
  void dispose() {
    agoraEngine.disableVideo();
    agoraEngine.disableAudio();
    super.dispose();
  }
}
