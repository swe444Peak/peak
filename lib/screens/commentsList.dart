import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/comment.dart';
import 'package:peak/models/goal.dart';

import 'package:peak/viewmodels/commentsList_model.dart';
import 'package:stacked/stacked.dart';

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
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text("Comments"),
            children: List<Widget>.generate(
              x(model).length,
              (int index) => widgets[index],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> x(model) {
    widgets = [];
    model.comments.forEach((comment) {
      widgets.add(SingleComment(comment));
    });
    Widget addAcommentWidget = ListTile(
      title: TextField(
        controller: commentController,
        // keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration:
            InputDecoration(hintText: 'Write a comment'), //join the discussion?
      ),
      trailing: IconButton(
        icon: Icon(Icons.send),
        onPressed: () async {
          await model.addComment(
              commentController.text, widget.goal.creatorGoalDocId);
          commentController.clear();
          //   scrollController.animateTo(
          //   scrollController.position.maxScrollExtent,
          //   curve: Curves.easeOut,
          //   duration: const Duration(milliseconds: 300),
          // );
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
      title: Text(comment.user.name),
      subtitle: Text(comment.text),
      leading: Container(
        padding: EdgeInsets.fromLTRB(0.0, height * 0.008, 0.0, height * 0.008),
        width: width * 0.15,
        height: width * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              comment.user.picURL,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
