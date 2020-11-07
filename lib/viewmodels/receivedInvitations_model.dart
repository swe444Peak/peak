import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/Invitation.dart';
import 'package:peak/services/databaseServices.dart';

import '../locator.dart';

class ReceivedInvitationsModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  ViewState _state = ViewState.Idle;
  List<Invitation> _invitations;

  ViewState get state => _state;
  List<Invitation> get invitations => _invitations;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void readInvitations(){
    setState(ViewState.Busy);
    _firstoreService.getReceivedInvations().listen((invitationData) {
      if(invitationData.isNotEmpty){
        _invitations = invitationData;
      }
      notifyListeners();
      setState(ViewState.Idle);
     }, onError: (error) => print(error));
  }//end readInvitations()

  bool acceptGoalInvite(Invitation invitation){
    setState(ViewState.Busy);
    dynamic result;
    result = _firstoreService.acceptGoalInvite(invitation);
    if(result == true){
      setState(ViewState.Idle);
      return true;
    }else{
      print(result);
      setState(ViewState.Idle);
      return false;
    }//end else
  }//end acceptGoalInvite()

  bool declinedGoalInvite(Invitation invitation){
    setState(ViewState.Busy);
    dynamic result;
    result = _firstoreService.declinedGoalInvite(invitation);
    if(result == true){
      setState(ViewState.Idle);
      return true;
    }else{
      print(result);
      setState(ViewState.Idle);
      return false;
    }//end else
  }//end declinedGoalInvite()
}
