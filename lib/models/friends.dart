import 'package:flutter/cupertino.dart';

class Friends {
  String userid1; //current
  String userid2; //other
  String fname; //

  Friends({
    @required this.userid1,
    @required this.userid2,
    this.fname,
  });

  static String getid1(Map<String, dynamic> map) {
    return map['userid1'];
  }

  static String getid2(Map<String, dynamic> map) {
    return map['userid2'];
  }

  Map<String, dynamic> toMap() {
    return {"userid1": this.userid1, "userid2": this.userid2};
  }
}
