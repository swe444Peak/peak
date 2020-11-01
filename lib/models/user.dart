import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class PeakUser {
  final String uid;
  final String name;
  final String picURL;
  // bool notificationStatus;

  PeakUser(
      {@required this.uid, this.name, this.picURL}); //this.notificationStatus

}
