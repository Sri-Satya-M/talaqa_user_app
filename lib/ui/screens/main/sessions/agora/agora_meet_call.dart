import 'dart:async';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/model/chat.dart';
import 'package:alsan_app/model/environment.dart';
import 'package:alsan_app/model/session.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/remote_user_preview.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/user_preview.dart';
import 'package:alsan_app/ui/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../bloc/sesssion_bloc.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/images.dart';
import 'agora_chat_screen.dart';

class AgoraMeetScreen extends StatefulWidget {
  final Session session;
  final Duration duration;
  final String token;
  final int hitTime;

  const AgoraMeetScreen({
    super.key,
    required this.session,
    required this.duration,
    required this.token,
    required this.hitTime,
  });

  static Future open({
    required BuildContext context,
    required Session session,
    required Duration duration,
    required String token,
    required int hitTime,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgoraMeetScreen(
          session: session,
          duration: duration,
          token: token,
          hitTime: hitTime,
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
  bool remoteVideo = false;

  AssetImage audioIcon = const AssetImage(Images.mic);
  AssetImage videoIcon = const AssetImage(Images.videoOn);
  Icon volumeIcon = const Icon(Icons.volume_down_outlined);
  int? streamId;
  List<Message> chat = [];

  Timer? _timer;
  Timer? _hitTimer;
  bool isExtended = false;

  late Duration duration;
  late Duration hitDuration;
  late int totalTime;
  final Duration oneSecond = const Duration(seconds: 1);

  bool isTimerActive = false;

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
      RtcEngineContext(appId: Environment.agoraAppId),
    );

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        isJoined = true;
        setState(() {});
      }, onUserJoined: (
        RtcConnection connection,
        int remoteUid,
        int elapsed,
      ) {
        _remoteUid = remoteUid;
        if (widget.session.consultationMode == "VIDEO") {
          remoteVideo = true;
        }
        startTimer();
        setState(() {});
      }, onUserOffline: (
        RtcConnection connection,
        int remoteUid,
        UserOfflineReasonType reason,
      ) {
        if (widget.session.consultationMode == "VIDEO") {
          remoteVideo = true;
        }
        _remoteUid = null;
        pauseTimer();
        setState(() {});
      }, onStreamMessage: (
        RtcConnection connection,
        int remoteUid,
        int streamId,
        Uint8List data,
        int length,
        int sentTs,
      ) {
        print('Chat message');
        String msg = String.fromCharCodes(data);
        print(msg);
        var sessionsBloc = Provider.of<SessionBloc>(context, listen: false);
        sessionsBloc.addMessage(
          Message(
            uid: remoteUid,
            streamId: streamId,
            msg: msg,
          ),
        );
        setState(() {});
      }),
    );
    return agoraEngine;
  }

  void join() async {
    await agoraEngine.startPreview();
    agoraEngine.enableAudio();
    if (widget.session.consultationMode == "VIDEO") {
      agoraEngine.enableVideo();
    }

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: widget.token,
      channelId: widget.session.sessionId!,
      options: options,
      uid: widget.session.patientProfile!.id!,
    );

    try {
      var sessionsBloc = Provider.of<SessionBloc>(context, listen: false);
      await createDataStream();
      sessionsBloc.initializeStream();
    } on ChatError catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    duration = widget.duration;
    hitDuration = Duration(minutes: widget.hitTime);
    totalTime = widget.session.sessionTimeslots!.length * 60;
    super.initState();
    _startTimer();
    _hitIntervalTimer();

    video = widget.session.consultationMode == "VIDEO" ? true : false;
    initializeSDK();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                AgoraChatScreen.open(
                  context,
                  token: widget.token,
                  session: widget.session,
                  agoraEngine: agoraEngine,
                  streamId: streamId!,
                  chat: chat,
                  onMessage: (Message chat) {
                    this.chat.add(chat);
                  },
                );
              },
              icon: const Icon(Icons.chat),
            ),
            const SizedBox(width: 16),
          ],
        ),
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
                      isVideo: remoteVideo,
                      remoteUid: _remoteUid,
                      agoraEngine: agoraEngine,
                      channelName: widget.session.sessionId!,
                      session: widget.session,
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
                        imageUrl: widget.session.patientProfile?.imageUrl,
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
                                  isJoined = false;
                                  _remoteUid = null;
                                  // var duration =
                                  //     DateTime.now().difference(startTime);
                                  // var sessionBloc = Provider.of<SessionBloc>(
                                  //   context,
                                  //   listen: false,
                                  // );
                                  // agoraEngine.disableVideo();
                                  // agoraEngine.disableAudio();
                                  // await sessionBloc.updateSession(
                                  //   id: widget.session.id!,
                                  //   body: {
                                  //     "status": "COMPLETED",
                                  //     "duration": 30
                                  //   },
                                  // ).then(
                                  //   (value) => Navigator.pop(context),
                                  // );
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
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Container(
                      height: 40,
                      width: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyColors.lightOrange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.timer, height: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${(duration.inHours % 60).toString().padLeft(2, '0')}:'
                            '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
                            '${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: textTheme.bodyText1?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

    await agoraEngine.muteLocalAudioStream(!audio);
    setState(() {});
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

    await agoraEngine.setEnableSpeakerphone(volume);
    setState(() {});
  }

  Future<void> createDataStream() async {
    streamId = await agoraEngine.createDataStream(
      const DataStreamConfig(syncWithAudio: false, ordered: true),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(oneSecond, (timer) {
      duration -= oneSecond;
      if (duration.isNegative || duration == Duration.zero) {
        duration = Duration.zero;
        Navigator.pop(context, true);
      }
      setState(() {});
    });
  }

  void _hitIntervalTimer() async {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    _hitTimer = Timer.periodic(oneSecond, (timer) async {
      hitDuration -= oneSecond;
      if (hitDuration.isNegative || hitDuration == Duration.zero) {
        hitDuration = Duration(minutes: widget.hitTime);
        await sessionBloc.postDuration(body: {
          'sessionId': widget.session.id,
          'duration': widget.hitTime,
          'userType': 'PATIENT'
        });
      }
      setState(() {});
    });
  }

  void pauseTimer() {
    if (isTimerActive && _hitTimer != null) {
      _hitTimer?.cancel();
      isTimerActive = false;
    }
  }

  void startTimer() {
    if (!isTimerActive) {
      _hitIntervalTimer();
      isTimerActive = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hitTimer?.cancel();
    agoraEngine.disableVideo();
    agoraEngine.disableAudio();
    agoraEngine.release();
    super.dispose();
  }
}
