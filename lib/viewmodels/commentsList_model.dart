import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/models/comment.dart';
import 'package:peak/models/user.dart';
import 'package:peak/services/databaseServices.dart';
import 'package:peak/services/firebaseAuthService.dart';

import '../locator.dart';

class CommentsListModel extends ChangeNotifier {
  final _firstoreService = locator<DatabaseServices>();
  final _firebaseService = locator<FirbaseAuthService>();
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;
  List<Comment> comments = [];
  bool empty = false;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void getComments(String goalDocId) {
    List<String> ids = [];
    setState(ViewState.Busy);
    _firstoreService.getComments(goalDocId).listen((commentsData) async {
      List<Comment> updatedComments = commentsData;
      if (updatedComments != null) {
        if (updatedComments.length > 0) {
          empty = false;
          comments = updatedComments;

          comments.forEach((comment) {
            ids.add(comment.writerId);
          });
          List<PeakUser> users = await _firstoreService.getUsers(ids);
          comments.forEach((comment) {
            users.forEach((user) {
              if (comment.writerId == user.uid) {
                comment.user = user;
                return;
              }
            });
          });
        } else {
          empty = true;
        }
        notifyListeners();
      }
      setState(ViewState.Idle);
    }, onError: (error) => print(error));
  }

  Future addComment(String text, String goalDocId) async {
    setState(ViewState.Busy);
    Comment comment = Comment(
        text: text,
        creatorGoalDocId: goalDocId,
        time: DateTime.now(),
        writerId: _firebaseService.currentUser.uid);
    await _firstoreService.writeComment(comment);
    setState(ViewState.Idle);
  }
}
