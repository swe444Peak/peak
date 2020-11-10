import 'dart:core';
import 'package:peak/enums/InvationStatus.dart';

class Invitation {
  String creatorId;
  String receiverId;
  InvationStatus status;
  String creatorgoalDocId;
  String invationDocId;
  String goalName;
  DateTime goalDueDate;
  int numOfTasks;

  Invitation(
      {creatorId,
      receiverId,
      status,
      creatorgoalDocId,
      invationDocId,
      goalName,
      goalDueDate,
      numOfTasks}) {
    this.creatorId = creatorId;
    this.receiverId = receiverId;
    this.status = status;
    this.invationDocId = invationDocId;
    this.creatorgoalDocId = creatorgoalDocId;
    this.goalName = goalName;
    this.goalDueDate = goalDueDate;
    this.numOfTasks = numOfTasks;
  }

  Map<String, dynamic> toMap() {
    return {
      "creatorId": this.creatorId,
      "receiverId": this.receiverId,
      "status": this.status.toShortString(),
      "creatorgoalDocId": this.creatorgoalDocId,
      "goalName": this.goalName,
      "goalDueDate": this.goalDueDate,
      "numOfTasks": this.numOfTasks,
    };
  }

  static Invitation fromJson(Map<String, dynamic> map, String invationDocId) {
    return Invitation(
      creatorId: map["creatorId"],
      receiverId: map["receiverId"],
      status: map["status"].formString(),
      creatorgoalDocId: map["creatorgoa)lDocId"],
      invationDocId: map["invationDocId"],
      goalName: map["goalName"],
      goalDueDate: map["goalDueDate"],
      numOfTasks: map["numOfTasks"],
    );
  }
}