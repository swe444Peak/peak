import 'dart:core';

import 'package:peak/models/user.dart';

class Comment {
  String writerId;
  String text;
  DateTime time;
  String creatorGoalDocId;
  PeakUser user;

  Comment({this.text, this.writerId, this.time, this.creatorGoalDocId});

  Map<String, dynamic> toMap() {
    return {
      "text": this.text,
      "writerId": this.writerId,
      "time": this.time,
      "creatorGoalDocId": this.creatorGoalDocId
    };
  }

  static Comment fromJson(Map<String, dynamic> map) {
    return Comment(
        text: map["text"],
        writerId: map["writerId"],
        time: map['time'].toDate(),
        creatorGoalDocId: map["creatorGoalDocId"]);
  }
}
