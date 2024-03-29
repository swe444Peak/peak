import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:peak/models/badges.dart';

class PeakUser {
  final String uid;
  final String name;
  final String picURL;
  List<Badge> badges;
  // bool notificationStatus;

  PeakUser(
      {@required this.uid, this.name, this.picURL, this.badges});//this.notificationStatus

  static PeakUser fromJson(Map<String, dynamic> map, String docID) {
    if (map == null) {
      return null;
    }
    return PeakUser(
      name: map['username'],
      picURL: map['picURL'],
      uid: docID,
      badges: badgesFromJson(map['badges']),
    );
  }

  static List<Badge> badgesFromJson(List<dynamic> jBages){
    if(jBages == null){
      return [];
    }
    List<Badge> badges = List<Badge>();
    jBages.forEach((b) {
      badges.add(Badge.fromJson(b));
     });
     return badges;
  }
}
