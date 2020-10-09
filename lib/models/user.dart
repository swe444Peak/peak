import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class PeakUser {
  final String uid;
  final String name;
  bool notificationStatus;

  PeakUser({@required this.uid, this.name, this.notificationStatus});
}
 
