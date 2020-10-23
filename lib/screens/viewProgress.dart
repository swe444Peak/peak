import 'package:flutter/material.dart';
import 'package:peak/enums/viewState.dart';

import 'package:peak/viewmodels/viewProgress_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stacked/stacked.dart';

import '../locator.dart';

class ViewProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return ViewModelBuilder<ViewProgressModel>.reactive(
      viewModelBuilder: () => locator<ViewProgressModel>(),
      onModelReady: (model) => model.readGoals(),
      builder: (context, model, child) => Container(
        width: width * 0.8,
        height: width * 0.9,
        child: model.state == ViewState.Busy
            ? CircularProgressIndicator()
            : Card(
                color: Colors.white,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: width * 0.08, horizontal: width * 0.03),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: width * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SleekCircularSlider(
                              initialValue: model.clacToatlProgress(),
                              appearance: CircularSliderAppearance(
                                size: width * 0.5,
                                startAngle: 0,
                                angleRange: 360,
                                customColors: CustomSliderColors(
                                    progressBarColors: [
                                      Colors.teal[400],
                                      Colors.indigo[600],
                                      Colors.deepPurple[900]
                                    ],
                                    trackColor: Colors.grey[300]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0.0, width * 0.01, width * 0.02, 0.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * 0.008),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Goals",
                                    style: TextStyle(fontSize: width * 0.045),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: width * 0.03),
                                  child: Text(
                                      "${model.empty ? 0 : model.goals.length}"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, width * 0.01, width * 0.02, 0.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * 0.008),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Achieved",
                                    style: TextStyle(fontSize: width * 0.045),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: width * 0.03),
                                  child: Text("${model.calcAchieved()}"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                width * 0.02, width * 0.01, 0, 0.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(width * 0.008),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Unachieved",
                                    style: TextStyle(fontSize: width * 0.045),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: width * 0.03),
                                  child: Text("${model.unachieved}"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
