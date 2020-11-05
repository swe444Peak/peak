import 'dart:core';

class Invation {
  String creatorId;
  String receiverId;
  bool status;
  List<String> goalDocIds;
  String invationDocId;

  Invation({creatorId, receiverId, status, goalDocIds, invationDocId}) {
    this.creatorId = creatorId;
    this.receiverId = receiverId;
    this.status = status;
    this.invationDocId = invationDocId;
    this.goalDocIds = goalDocIds == null ? List<String>() : goalDocIds;
  }

  Map<String, dynamic> toMap() {
    return {
      "creatorId": this.creatorId,
      "receiverId": this.receiverId,
      "status": this.status,
      "goalDocIds": this.goalDocIds,
    };
  }

  static Invation fromJson(Map<String, dynamic> map, String invationDocId) {
    return Invation(
      creatorId: map["creatorId"],
      receiverId: map["receiverId"],
      status: map["status"],
      goalDocIds: map["goalDocIds"].toList(),
      invationDocId: map["invationDocId"],
    );
  }
}
