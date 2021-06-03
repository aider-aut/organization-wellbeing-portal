import 'dart:convert';

import 'package:chatapp/main/screens/business_summary_view.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessScreen extends StatefulWidget {
  BusinessScreen({
    Key key,
    @required this.business,
  }) : super(key: key);
  final String business;

  @override
  State<StatefulWidget> createState() => _BusinessState(business);
}

class _BusinessState extends State<BusinessScreen> {
  List<User> _employees = [];
  String emotion = 'Happy';
  double average = 0.0;
  final String business;
  _BusinessState(this.business);

  @override
  void initState() {
    super.initState();
    emotion = UserRepo().getEmotion();
  }

  void calculateWellbeing(emotion) {
    switch (emotion) {
      case 'Happy':
        average += 1.0;
        break;
      case 'Angry':
        average - 1.0 >= 0.0 ? average -= 1.0 : average = 0;
        break;
      case 'Confused':
        average - 0.5 >= 0.0 ? average -= 0.5 : average = 0;
        break;
      case 'Sad':
        average - 0.5 >= 0.0 ? average -= 0.5 : average = 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserRepo().getSnapshotsOfUsers(),
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
            snapshot.data.docs.forEach((user) {
              User pulledUser =
                  User.fromJson(jsonDecode(json.encode(user.data())));
              if (pulledUser.tenantId != "Employer" &&
                  pulledUser.business == business) {
                _employees.add(pulledUser);
              }
            });
            _employees.forEach((user) {
              calculateWellbeing(user.emotion);
            });
            calculateWellbeing(emotion);
            average = average / (_employees.length + 1);
            return BusinessSummaryScreen(
                average: average, employees: _employees);
          }
        });
  }
}
