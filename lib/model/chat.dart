class Message {
  Message({this.uid, this.streamId, this.msg});

  int? uid;
  int? streamId;
  String? msg;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        uid: json["uid"],
        streamId: json["streamId"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "streamId": streamId,
        "msg": msg,
      };
}
