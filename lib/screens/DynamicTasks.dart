import 'package:flutter/material.dart';

class DynamicTasks extends StatelessWidget {
  TextEditingController task = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: new TextFormField(
                  controller: task,
                  decoration: const InputDecoration(
                      labelText: 'Task name', border: OutlineInputBorder()),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
