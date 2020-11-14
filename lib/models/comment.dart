import 'dart:core';

class Comment {
  String writerId;
  String text;

  Comment({this.text, this.writerId});

  Map<String, dynamic> toMap() {
    return {
      "text": this.text,
      "writerId": this.writerId,
    };
  }

  static Comment fromJson(Map<String, dynamic> map) {
    return Comment(text: map["text"], writerId: map["writerId"]);
  }
}
