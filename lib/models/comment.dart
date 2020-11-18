import 'dart:core';

import 'package:peak/models/user.dart';

class Comment {
  String writerId;
  String text;
  DateTime time;
  String creatorGoalDocId;
  PeakUser user;

  Comment(
      {this.text, this.writerId, this.time, this.creatorGoalDocId, this.user});

  Map<String, dynamic> toMap() {
    return {
      "text": this.text,
      "writerId": this.writerId,
      "time": this.time,
      "creatorGoalDocId": this.creatorGoalDocId,
      "user": {"uid": user.uid, "username": user.name, "picURL": user.picURL},
    };
  }

  static Comment fromJson(Map<String, dynamic> map) {
    PeakUser user = userfromJson(map['user']);
    print(user.name);
    print(map["text"]);
    return Comment(
        text: map["text"],
        writerId: map["writerId"],
        time: map['time'].toDate(),
        creatorGoalDocId: map["creatorGoalDocId"],
        user: user);
  }

  static PeakUser userfromJson(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return PeakUser(
      name: map['username'],
      picURL: map['picURL'],
      uid: map["uid"],
    );
  }
}
