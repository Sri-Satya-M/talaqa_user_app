import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraBloc with ChangeNotifier {
  String appId = "968ae33c48f744f1bcc1b7f120348c74";
  String? token;

  String? channel;

  int? uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool? isJoined = false; // Indicates if the local user has joined the channel
  RtcEngine? agoraEngine; // Agora engine instance

  Future<RtcEngine> setupVideoSDKEngine({
    required String token,
    required String channel,
  }) async {
    //initializtion
    this.token = token;
    this.channel = channel;

    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();

    await agoraEngine!.initialize(RtcEngineContext(appId: appId));

    // Register the event handler
    agoraEngine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          isJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _remoteUid = null;
          notifyListeners();
        },
      ),
    );
    return agoraEngine!;
  }

  void join() async {
    await agoraEngine!.startPreview();
    agoraEngine!.enableAudio();
    agoraEngine!.enableVideo();
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine!.joinChannel(
      token: token!,
      channelId: channel!,
      options: options,
      uid: uid!,
    );
  }

  void leave() {
    isJoined = false;
    _remoteUid = null;
    agoraEngine!.leaveChannel();
    notifyListeners();
  }

  @override
  void dispose() {
    token = null;
    channel = null;
    uid = null;
    _remoteUid;
    isJoined = false;
    agoraEngine = null;
    super.dispose();
  }
}
