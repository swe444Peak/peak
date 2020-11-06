enum InvationStatus { Pending, Accepted, Declined }

extension ParseToString on InvationStatus {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

extension ParseInvationStatus on String {
  InvationStatus formString() {
    if (this.toLowerCase() == "pending") return InvationStatus.Pending;
    if (this.toLowerCase() == "accepted") return InvationStatus.Accepted;
    if (this.toLowerCase() == "declined") return InvationStatus.Declined;
  }
}
