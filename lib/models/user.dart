import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class PeakUser {
  final String uid;
  final String name;
  final String picURL;
  // bool notificationStatus;

  PeakUser(
      {@required this.uid, this.name, this.picURL});//this.notificationStatus

   static PeakUser fromJson(Map<String, dynamic> map, String docID) {
    if (map == null) {
      return null;
    }
    return PeakUser(
      name: map['username'],
      picURL: map['picURL'], 
      uid: docID,
    );
  }
}
