import 'package:flutter/cupertino.dart';

class Friends {
  String userid1; //current
  String userid2; //other
  String fname; //
  String docID;

  Friends({
    @required this.userid1,
    @required this.userid2,
    this.fname,
    this.docID,
  });

  static Friends fromJson(Map<String, dynamic> map, String id) {
    return Friends(userid1: map["userid1"], userid2: map["userid2"], docID: id);
  }

  static String getid1(Map<String, dynamic> map) {
    return map['userid1'];
  }

  static String getid2(Map<String, dynamic> map) {
    return map['userid2'];
  }

  Map<String, dynamic> toMap() {
    return {"userid1": this.userid1, "userid2": this.userid2};
  }

  static Friends delGetid(Map<String, dynamic> map, String id) {
    return Friends(
      userid1: map['userid1'],
      userid2: map['userid2'],
      fname: map['fname'],
      docID: id,
    );
  }
}
