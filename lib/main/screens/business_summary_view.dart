import 'dart:convert';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BusinessSummaryScreen extends StatefulWidget {
  BusinessSummaryScreen({
    Key key,
    @required this.average,
    @required this.employees,
  }) : super(key: key);
  final double average;
  final List<User> employees;

  @override
  State<StatefulWidget> createState() =>
      _BusinessSummaryState(average, employees);
}

class _BusinessSummaryState extends State<BusinessSummaryScreen> {
  List<User> _employees = [];
  List<String> unhealthy_thoughts;
  String uid;
  final double average;
  _BusinessSummaryState(this.average, this._employees);

  @override
  void initState() {
    super.initState();
    uid = UserRepo().getUserId();
    unhealthy_thoughts = new List<String>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserRepo().getSnapshotsOfWellbeingData(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor),
              child: Center(
                child: Text('Something went wrong'),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                ));
          } else {
            snapshot.data.docs.forEach((wellbeing) {
              _employees.forEach((employee) {
                if (wellbeing.id == employee.uid) {
                  final userData = jsonDecode(json.encode(wellbeing.data()));
                  unhealthy_thoughts.add(userData['unhealthy_thoughts']);
                }
              });
            });
            return Container(
                height: MediaQuery.of(context).size.height - 305,
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 13.0,
                          animation: true,
                          percent: average,
                          center: new Text(
                            "${average * 100}%",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          footer: new Text(
                            "Avg. emotional wellbeing",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: average > 0.5
                              ? Colors.green
                              : average <= 0.5 && average > 0.3
                                  ? Colors.yellow
                                  : Colors.red,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: unhealthy_thoughts.length > 0
                            ? Text(
                                "${unhealthy_thoughts.length} of your employees ${unhealthy_thoughts.length > 1 ? "are" : "is"} having unhealthy thoughts")
                            : Text(
                                "Great news. None of your employees are having unhealthy thoughts"),
                      )
                    ])));
          }
        });
  }
}
