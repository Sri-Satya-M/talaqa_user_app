import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

class UserPreview extends StatefulWidget {
  final bool isVideo;
  final RtcEngine agoraEngine;
  final String username;
  final String? imageUrl;

  const UserPreview({
    super.key,
    required this.isVideo,
    required this.agoraEngine,
    required this.username,
    this.imageUrl,
  });

  @override
  _UserPreviewState createState() => _UserPreviewState();
}

class _UserPreviewState extends State<UserPreview> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: (widget.isVideo)
          ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: widget.agoraEngine,
                canvas: const VideoCanvas(
                  uid: 0,
                ),
              ),
            )
          : Container(
              color: Colors.black87,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(
                    name: widget.username,
                    url: widget.imageUrl,
                    borderRadius: BorderRadius.circular(40),
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.username,
                    style: textTheme.headline4?.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
    );
  }
}
