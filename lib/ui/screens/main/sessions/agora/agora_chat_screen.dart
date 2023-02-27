import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../model/session.dart';

class AgoraChatScreen extends StatefulWidget {
  final String token;
  final int streamId;
  final Session session;
  final RtcEngine agoraEngine;

  const AgoraChatScreen({
    super.key,
    required this.token,
    required this.streamId,
    required this.session,
    required this.agoraEngine,
  });

  static Future open(
    BuildContext context, {
    required String token,
    required int streamId,
    required Session session,
    required RtcEngine agoraEngine,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgoraChatScreen(
          token: token,
          streamId: streamId,
          session: session,
          agoraEngine: agoraEngine,
        ),
      ),
    );
  }

  @override
  _AgoraChatScreenState createState() => _AgoraChatScreenState();
}

class _AgoraChatScreenState extends State<AgoraChatScreen> {
  @override
  void initState() {
    super.initState();
    sendStreamMessage(msg: "Hi Yashwanth");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Container(),
    );
  }

  Future<void> sendStreamMessage({
    required String msg,
  }) async {
    List<int> codeUnits = msg.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    widget.agoraEngine.sendStreamMessage(
      streamId: widget.streamId,
      data: uint8list,
      length: uint8list.length,
    );
  }
}
