import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peak/models/comment.dart';
import 'package:peak/models/goal.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:peak/viewmodels/commentsList_model.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../locator.dart';

class CommentsList extends StatefulWidget {
  Goal goal;
  CommentsList(this.goal);
  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  List<Widget> widgets = [];
  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ViewModelBuilder<CommentsListModel>.reactive(
      viewModelBuilder: () => locator<CommentsListModel>(),
      onModelReady: (model) => model.getComments(widget.goal.creatorGoalDocId),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          child: ExpansionTile(
            backgroundColor: Colors.white,
            leading: Icon(Icons.comment),
            trailing: Text(model.comments.length.toString()),
            title: Text("Discussion"),
            children: List<Widget>.generate(
              x(model, width).length,
              (int index) => widgets[index],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> x(model, width) {
    widgets = [];
    model.comments.forEach((comment) {
      widgets.add(SingleComment(comment));
    });
    Widget addAcommentWidget = ListTile(
      title: TextField(
        controller: commentController,
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              width * 0.05, width * 0.001, width * 0.005, 0),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: model.comments.length == 0
              ? 'Start a discussion!'
              : 'Join the discussion!',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ), //join the discussion?
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.send,
          color: Colors.blue,
        ),
        onPressed: () async {
          if (commentController.text.trim() != '') {
            await model.addComment(
                commentController.text, widget.goal.creatorGoalDocId);
            commentController.clear();
          } else {
            Fluttertoast.showToast(
                msg: "Nothing to send!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.amberAccent[400],
                textColor: Colors.white,
                fontSize: width * 0.04);
          }
        },
      ),
    );
    widgets.add(addAcommentWidget);
    return widgets;
  }
}

class SingleComment extends StatelessWidget {
  Comment comment;
  SingleComment(this.comment);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ListTile(
      tileColor: Colors.white,
      title: Text(comment.username),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.007),
            child: Text(comment.text),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Timeago(
                  builder: (_, value) =>
                      Text(timeago.format(comment.time, allowFromNow: true)),
                  date: comment.time,
                  refreshRate: Duration(minutes: 1)),
            ],
          )
        ],
      ),
      leading: Container(
        padding: EdgeInsets.fromLTRB(0.0, height * 0.008, 0.0, height * 0.008),
        width: width * 0.15,
        height: width * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              comment.picURL,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
