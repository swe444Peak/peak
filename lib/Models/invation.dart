import 'dart:core';
import 'package:peak/enums/InvationStatus.dart';

class Invation {
  String creatorId;
  String receiverId;
  InvationStatus status;
  String creatorgoalDocId;
  String invationDocId;

  Invation({creatorId, receiverId, status, creatorgoalDocId, invationDocId}) {
    this.creatorId = creatorId;
    this.receiverId = receiverId;
    this.status = status;
    this.invationDocId = invationDocId;
    this.creatorgoalDocId = creatorgoalDocId;
  }

  Map<String, dynamic> toMap() {
    return {
      "creatorId": this.creatorId,
      "receiverId": this.receiverId,
      "status": this.status.toShortString(),
      "creatorgoalDocId": this.creatorgoalDocId,
    };
  }

  static Invation fromJson(Map<String, dynamic> map, String invationDocId) {
    return Invation(
      creatorId: map["creatorId"],
      receiverId: map["receiverId"],
      status: map["status"].formString(),
      creatorgoalDocId: map["creatorgoa)lDocId"],
      invationDocId: map["invationDocId"],
    );
  }
}
