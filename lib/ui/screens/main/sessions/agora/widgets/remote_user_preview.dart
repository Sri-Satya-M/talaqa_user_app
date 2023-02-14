import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class RemoteUserPreview extends StatefulWidget {
  final bool isJoined;
  final RtcEngine agoraEngine;
  final int? remoteUid;
  final String channelName;
  final String userName;

  const RemoteUserPreview({
    super.key,
    required this.isJoined,
    required this.agoraEngine,
    this.remoteUid,
    required this.channelName,
    required this.userName,
  });

  @override
  _RemoteUserPreviewState createState() => _RemoteUserPreviewState();
}

class _RemoteUserPreviewState extends State<RemoteUserPreview> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    if (widget.remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: widget.agoraEngine,
          canvas: VideoCanvas(uid: widget.remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Waiting for ",
              style: textTheme.headline3,
            ),
            TextSpan(
              text: widget.userName,
              style: textTheme.headline4,
            ),
            TextSpan(
              text: " to join",
              style: textTheme.headline3,
            ),
          ],
        ),
      );
    }
  }
}
