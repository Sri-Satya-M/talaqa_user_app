import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/remote_user_preview.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/user_preview.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:alsan_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/agora_bloc.dart';
import '../../../../../resources/images.dart';

class AgoraMeetScreen extends StatefulWidget {
  final int? uid;
  final Session session;

  const AgoraMeetScreen({
    super.key,
    this.uid,
    required this.session,
  });

  static Future open(
    BuildContext context, {
    required int uid,
    required Session session,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgoraMeetScreen(
          uid: uid,
          session: session,
        ),
      ),
    );
  }

  @override
  _AgoraMeetScreenState createState() => _AgoraMeetScreenState();
}

class _AgoraMeetScreenState extends State<AgoraMeetScreen> {
  int? _remoteUid; // uid of the remote user
  bool? isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  bool audio = true;
  bool video = true;
  bool volume = false;

  AssetImage audioIcon = const AssetImage(Images.mic);
  AssetImage videoIcon = const AssetImage(Images.videoOn);
  Icon volumeIcon = const Icon(Icons.volume_down_outlined);

  initializeSDK() async {
    // Set up an instance of Agora engine
    agoraEngine = await setupVideoSDKEngine();
    isJoined = true;
    join();
    setState(() {});
  }

  Future<RtcEngine> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();

    await agoraEngine.initialize(
      const RtcEngineContext(appId: Constants.appId),
    );

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined = true;
          setState(() {});
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
          setState(() {});
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _remoteUid = null;
          setState(() {});
        },
      ),
    );
    return agoraEngine;
  }

  void join() async {
    await agoraEngine.startPreview();
    agoraEngine.enableAudio();
    if (widget.session.consultationMode == "VIDEO") {
      agoraEngine.enableVideo();
    }
    await agoraEngine.setDefaultAudioRouteToSpeakerphone(true);
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token:
          '007eJxTYHC08WllCNygHa+8JF9D3JVdWnfXae0ARy//kp67ifkzOBQYLM0sElONjZNNLNLMTUzSDJOSkw2TzNMMjQyMTSySzU3EJd8lNwQyMsxaL8HKyACBID47g6NPsIGBgSEDAwD6zxoX',
      channelId: true ? "ALS0001" : widget.session.sessionId!,
      options: options,
      uid: widget.session.patientProfile!.id!,
    );
  }

  @override
  void initState() {
    super.initState();
    video = widget.session.consultationMode == "VIDEO" ? true : false;
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
                      channelName: widget.session.sessionId!,
                      isVideo: video,
                      userName:
                          "Dr. ${widget.session.clinician!.user!.fullName!}",
                      imageUrl: widget.session.clinician?.imageUrl,
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
                        username: widget.session.patientProfile!.fullName!,
                        imageUrl: widget.session.patientProfile?.image,
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
                                  // callBloc.leave();
                                  isJoined = false;
                                  _remoteUid = null;
                                  // agoraEngine.leaveChannel();
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
                            if (widget.session.consultationMode == "VIDEO") ...[
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: FloatingActionButton(
                                  onPressed: switchCamera,
                                  child: const Icon(
                                      Icons.flip_camera_android_sharp,
                                      size: 25),
                                ),
                              ),
                              const SizedBox(width: 24),
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: FloatingActionButton(
                                  onPressed: setVideoEnabled,
                                  child: ImageIcon(videoIcon, size: 25),
                                ),
                              ),
                            ],
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

  switchCamera() async {
    await agoraEngine.switchCamera();
  }

  setAudioEnabled() async {
    audio = !audio;
    audioIcon = AssetImage((audio) ? Images.mic : Images.micOff);
    await agoraEngine.muteLocalAudioStream(!audio).then(
          (value) => setState(() {}),
        );
  }

  setVideoEnabled() async {
    video = !video;
    videoIcon = AssetImage((video) ? Images.videoOn : Images.videoOff);
    await agoraEngine.enableLocalVideo(video);
    setState(() {});
  }

  setSpeakerPhone() async {
    volume = !volume;
    volumeIcon = Icon(
      (volume) ? Icons.volume_up_outlined : Icons.volume_down_outlined,
    );

    await agoraEngine.setDefaultAudioRouteToSpeakerphone(volume).then(
          (value) => setState(() {}),
        );
  }

  String generateToken({
    required int uid,
    required String channelName,
  }) {
    // replace with your Agora App Id
    String appId = Constants.appId;

    // replace with your Agora App Certificate
    String appCertificate = Constants.primaryCertificatte;

    int expirationTimeInSeconds = 3600 *
        widget.session.clinicianTimeSlotIds!
            .length; // token expiration time in seconds
    int currentTimeInSeconds = DateTime.now().toUtc().hour ~/ 1000;
    int privilegeExpiredTs = currentTimeInSeconds + expirationTimeInSeconds;

    String originToken =
        '1:$appId:$privilegeExpiredTs:$uid:$channelName:$appCertificate';

    String token = generateAccessToken(
      appId: Constants.appId,
      appCertificate: Constants.primaryCertificatte,
      channelName: channelName,
      uid: uid,
      privilegeExpiredTs: privilegeExpiredTs,
    );
    return token;
  }

  String generateAccessToken({
    required String appId,
    required String appCertificate,
    required String channelName,
    required int uid,
    required int privilegeExpiredTs,
  }) {
    String originToken =
        '1:$appId:$privilegeExpiredTs:$uid:$channelName:$appCertificate';
    return generateTokenWithOriginToken(originToken: originToken);
  }

  String generateTokenWithOriginToken({required String originToken}) {
    var bytes = utf8.encode(originToken);
    String token = base64.encode(bytes);
    return token;
  }

  @override
  void dispose() {
    agoraEngine.disableVideo();
    agoraEngine.disableAudio();
    agoraEngine.release();
    super.dispose();
  }
}
