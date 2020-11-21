import 'dart:core';

class Comment {
  String writerId;
  String text;
  DateTime time;
  String creatorGoalDocId;
  String username;
  String picURL;

  Comment(
      {this.text,
      this.writerId,
      this.time,
      this.creatorGoalDocId,
      this.username,
      this.picURL});

  Map<String, dynamic> toMap() {
    return {
      "text": this.text,
      "writerId": this.writerId,
      "time": this.time,
      "creatorGoalDocId": this.creatorGoalDocId,
      "username": this.username,
      "picURL": this.picURL,
    };
  }

  static Comment fromJson(Map<String, dynamic> map) {
    return Comment(
        text: map["text"],
        writerId: map["writerId"],
        time: map['time'].toDate(),
        creatorGoalDocId: map["creatorGoalDocId"],
        username: map['username'],
        picURL: map['picURL']);
  }
}
