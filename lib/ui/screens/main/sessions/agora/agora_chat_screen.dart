import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alsan_app/bloc/session_bloc.dart';
import 'package:alsan_app/model/chat.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/other_bubble.dart';
import 'package:alsan_app/ui/screens/main/sessions/agora/widgets/self_bubble.dart';
import 'package:alsan_app/ui/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../../model/session.dart';

class AgoraChatScreen extends StatefulWidget {
  final String token;
  final int streamId;
  final Session session;
  final RtcEngine agoraEngine;
  final List<Message> chat;
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
      required List<Message> chat}) {
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
    var sessionsBloc = Provider.of<SessionBloc>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F2F2),
      appBar: AppBar(title: Text(widget.session.sessionId!)),
      body: StreamBuilder<List<Message>>(
        stream: sessionsBloc.messageListStream,
        builder: (context, snapshot) {
          var chatMessages = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              return (widget.session.patientProfile!.id ==
                      chatMessages[index].uid)
                  ? SelfBubble(
                      message: chatMessages[index].msg!,
                      session: widget.session,
                    )
                  : OtherBubble(
                      message: chatMessages[index].msg!,
                      session: widget.session,
                    );
            },
          );
        },
      ),
      extendBody: true,
      bottomSheet: CustomCard(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
        cardColor: Colors.white,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            scrollPadding: const EdgeInsets.only(bottom: 20),
            maxLines: null,
            controller: msgController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: InputBorder.none,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  String msg = msgController.text;
                  if (msg == null ||
                      msg.isEmpty ||
                      msgController.text.trim().isEmpty) return;
                  sendStreamMessage(msg: msg);
                  Message newMessage = Message(
                    uid: widget.session.patientProfile!.id,
                    streamId: widget.streamId,
                    msg: msg,
                  );
                  sessionsBloc.addMessage(newMessage);
                  msgController.clear();
                  setState(() {});
                },
              ),
            ),
          ),
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

  PersistentBottomSheetController sample() {
    var sessionBloc = Provider.of<SessionBloc>(context, listen: false);
    return showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return CustomCard(
          cardColor: Colors.white,
          shadowColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    String msg = msgController.text;
                    if (msg == null ||
                        msg.isEmpty ||
                        msgController.text.trim().isEmpty) return;
                    sendStreamMessage(msg: msg);
                    Message newMessage = Message(
                      uid: widget.session.patientProfile!.id,
                      streamId: widget.streamId,
                      msg: msg,
                    );
                    sessionBloc.addMessage(newMessage);
                    msgController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
