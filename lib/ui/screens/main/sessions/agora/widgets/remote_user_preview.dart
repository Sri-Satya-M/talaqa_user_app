import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/avatar.dart';

class RemoteUserPreview extends StatefulWidget {
  final bool isJoined;
  final RtcEngine agoraEngine;
  final int? remoteUid;
  final String channelName;
  final String userName;
  final bool isVideo;
  final String? imageUrl;

  const RemoteUserPreview(
      {super.key,
      required this.isJoined,
      required this.agoraEngine,
      this.remoteUid,
      required this.channelName,
      required this.userName,
      required this.isVideo,
      this.imageUrl});

  @override
  _RemoteUserPreviewState createState() => _RemoteUserPreviewState();
}

class _RemoteUserPreviewState extends State<RemoteUserPreview> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    if (widget.remoteUid != null) {
      return (widget.isVideo)
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: widget.agoraEngine,
                canvas: VideoCanvas(uid: widget.remoteUid),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            )
          : Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(
                    name: widget.userName,
                    url: widget.imageUrl,
                    borderRadius: BorderRadius.circular(75),
                    size: 150,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.userName,
                    style: textTheme.headline4?.copyWith(color: Colors.black),
                  )
                ],
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
