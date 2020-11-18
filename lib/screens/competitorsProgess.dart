import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/comment.dart';
import 'package:peak/models/compitetor.dart';
import 'package:peak/models/goal.dart';

import 'package:peak/viewmodels/competitorsProgress_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';

class CompetitorsProgress extends StatefulWidget {
  Goal goal;
  String cuid;
  CompetitorsProgress(this.goal, this.cuid);
  @override
  _CompetitorsProgressState createState() => _CompetitorsProgressState();
}

class _CompetitorsProgressState extends State<CompetitorsProgress> {
  List<Widget> widgets = [];
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return ViewModelBuilder<CompetitorsProgressModel>.reactive(
        viewModelBuilder: () => locator<CompetitorsProgressModel>(),
        onModelReady: (model) =>
            model.getCompetitorsGoals(widget.goal.creatorGoalDocId),
        builder: (context, model, child) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: competitorsCards(model, width, height, widget.cuid),
              ),
            ));
  }

  List<Widget> competitorsCards(model, width, height, cuid) {
    widgets = [];
    model.comps.forEach((comp) {
      if (comp.user.uid != cuid) widgets.add(CompetetorCard(comp));
    });
    return widgets;
  }
}

class CompetetorCard extends StatelessWidget {
  Compitetor comp;
  CompetetorCard(this.comp);
  @override
  Widget build(BuildContext context) {
    print(comp.user.toString());
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Card(
        //card Property
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(width * 0.008),
          child: ListTile(
            //tileColor: Colors.white,
            title: Row(
              children: [
                SizedBox(width: width * 0.03),
                Text(
                  comp.user.name,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                //progress
              ],
            ),
            subtitle: Container(
              padding:
                  EdgeInsets.fromLTRB(0.0, height * 0.008, 0.0, height * 0.008),
              child: LinearPercentIndicator(
                width: width * 0.55,
                lineHeight: 14.0,
                percent: comp.goal.calcProgress(),
                backgroundColor: Colors.indigo[900],
                progressColor: Colors.blue,
                center: Text(
                  "${(comp.goal.calcProgress() * 100).toStringAsFixed(2)}%",
                  style: new TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ),
            leading: Container(
              padding:
                  EdgeInsets.fromLTRB(0.0, height * 0.008, 0.0, height * 0.008),
              width: width * 0.15,
              height: width * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(comp.user.picURL),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black26,
                    offset: new Offset(0.0, -8.0),
                    blurRadius: 40.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
            ),
            onTap: () {
              //Navigator.pushNamed(context, "goalDetails", arguments: goal);
            },
          ),
        ));
  }
}

// compitetorsList(model, width, height) {
//   return ListView.builder(
//       itemCount: model.compitetorsGs.length,
//       itemBuilder: (context, index) {
//         var comG = model.compitetorsGs[index];
// return Card(
//     //card Property
//     elevation: 20,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(20.0),
//     ),
//     child: Padding(
//       padding: EdgeInsets.all(width * 0.008),
//               child: ListTile(
//                 tileColor: Colors.white,
//                 title: Row(
//                   children: [
//                     SizedBox(width: width * 0.03),
//                     Text(
//                       comp.user.name,
//                       style: TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 18,
//                       ),
//                     ),
//                     Spacer(),
//                     //progress
//                   ],
//                 ),
//                 leading: Container(
//                   padding: EdgeInsets.fromLTRB(
//                       0.0, height * 0.008, 0.0, height * 0.008),
//                   width: width * 0.15,
//                   height: width * 0.15,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(comp.user.picURL),
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: BorderRadius.circular(100),
//                     boxShadow: [
//                       new BoxShadow(
//                         color: Colors.black26,
//                         offset: new Offset(0.0, -8.0),
//                         blurRadius: 40.0,
//                         spreadRadius: 1.0,
//                       )
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   //Navigator.pushNamed(context, "goalDetails", arguments: goal);
//                 },
//               ),
//             ));
//       });
// }
