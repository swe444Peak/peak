import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';
import 'package:peak/viewmodels/viewBadges_model.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';

class ViewBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return ViewModelBuilder<ViewBadgesModel>.reactive(
      viewModelBuilder: () => locator<ViewBadgesModel>(),
      onModelReady: (model) => model.readBadges(),
      builder: (context, model, child) => Container(
        width: width * 0.8,
        height: width * 0.8,
        child: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : GridView.count(
              //padding: EdgeInsets.all(width * 0.01),
              //crossAxisSpacing: 10,
              //mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              children: List.generate(4, (index) {
                return Card(
                  color: Colors.white,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.01, horizontal: width * 0.01),
                    child: Column(
                      children: [
                        Image.asset("${getBadge(model.badges[index].name, model.badges[index].status)}",
                        width: width * 0.22,),
                        Text(model.badges[index].name, 
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                        ),
                        Text(model.badges[index].description,
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: width * 0.033,
                        ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
      ),
    );
  }

  String getBadge(String badge, bool status){
    switch(badge){
      case "First goal":
                          if(status){
                            return "assets/badges/first_goal_colored.png";
                          }else{
                            return "assets/badges/first_goal_grey.png";
                          }
                          break;
      case "Achieve first task":
                          if(status){
                            return "assets/badges/firstTask_colored.png";
                          }else{
                            return "assets/badges/firstTask_gray.png";
                          }
                          break;
      case "50% Total Progress":
                          if(status){
                            return "assets/badges/totalProgress_colored.png";
                          }else{
                            return "assets/badges/totalProgress_gray.png";
                          }
                          break;
      case "3 days of 100% productivity":
                          if(status){
                            return "assets/badges/threeTasks_colored.png";
                          }else{
                            return "assets/badges/threeTasks_gray.png";
                          }
    }//end switch
    return "";
  }
}
