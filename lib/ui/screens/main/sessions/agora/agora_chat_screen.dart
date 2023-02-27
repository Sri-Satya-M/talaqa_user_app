import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/other_bubble.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/self_bubble.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../model/session.dart';
import 'agora_meet_call.dart';

class AgoraChatScreen extends StatefulWidget {
  final String token;
  final int streamId;
  final Session session;
  final RtcEngine agoraEngine;
  final List<Chat> chat;
  final Function onMessage;

  const AgoraChatScreen({
    super.key,
    required this.token,
    required this.streamId,
    required this.session,
    required this.agoraEngine,
    required this.chat,
    required this.onMessage,
  });

  static Future open(BuildContext context,
      {required String token,
      required int streamId,
      required Session session,
      required RtcEngine agoraEngine,
      required Function onMessage,
      required List<Chat> chat}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgoraChatScreen(
          onMessage: onMessage,
          token: token,
          streamId: streamId,
          session: session,
          agoraEngine: agoraEngine,
          chat: chat,
        ),
      ),
    );
  }

  @override
  _AgoraChatScreenState createState() => _AgoraChatScreenState();
}

class _AgoraChatScreenState extends State<AgoraChatScreen> {
  TextEditingController msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F2F2),
      appBar: AppBar(title: const Text("Chat")),
      body: ListView.builder(
          itemCount: widget.chat.length,
          itemBuilder: (context, index) {
            return (widget.session.patientProfile!.id == widget.chat[index].uid)
                ? SelfBubble(message: widget.chat[index].msg!)
                : OtherBubble(message: widget.chat[index].msg!);
          }),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: msgController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (msgController.text == null ||
                            msgController.text.isEmpty) return;
                        sendStreamMessage(msg: msgController.text);
                        Chat newChat = Chat(
                            uid: widget.session.patientProfile!.id,
                            streamId: widget.streamId,
                            msg: msgController.text);
                        widget.onMessage.call(newChat);
                        msgController.clear();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
