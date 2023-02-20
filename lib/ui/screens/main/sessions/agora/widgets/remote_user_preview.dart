import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/model/session.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/avatar.dart';

class RemoteUserPreview extends StatefulWidget {
  final bool isJoined;
  final bool isVideo;
  final int? remoteUid;
  final String channelName;
  final RtcEngine agoraEngine;
  final Session session;

  const RemoteUserPreview({
    super.key,
    required this.isJoined,
    required this.isVideo,
    this.remoteUid,
    required this.agoraEngine,
    required this.channelName,
    required this.session,
  });

  @override
  _RemoteUserPreviewState createState() => _RemoteUserPreviewState();
}

class _RemoteUserPreviewState extends State<RemoteUserPreview> {
  late String name;
  String? imageUrl;

  @override
  void initState() {
    name = widget.session.clinician!.user!.fullName!;
    imageUrl = widget.session.clinician?.imageUrl;
    super.initState();
  }

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
                    name: name,
                    url: imageUrl,
                    borderRadius: BorderRadius.circular(75),
                    size: 150,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: textTheme.headline4?.copyWith(color: Colors.black),
                  )
                ],
              ),
            );
    } else {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Waiting for ", style: textTheme.headline3),
            TextSpan(text: name, style: textTheme.headline4),
            TextSpan(text: " to join", style: textTheme.headline3),
          ],
        ),
      );
    }
  }
}
