import 'dart:convert';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmployeeScreen extends StatefulWidget {
  EmployeeScreen({
    Key key,
    @required this.imgUrls,
    @required this.business,
  }) : super(key: key);
  final Map<String, String> imgUrls;
  final String business;

  @override
  State<StatefulWidget> createState() => _EmployeeState(imgUrls, business);
}

class _EmployeeState extends State<EmployeeScreen> {
  final Map<String, String> imgUrls;
  List<User> _employees = [];
  final String business;
  _EmployeeState(this.imgUrls, this.business);
  Map<String, String> emotions;

  @override
  void initState() {
    super.initState();
    emotions = {
      'Happy': 'assets/icons/emotions/happy-active.png',
      'Sad': 'assets/icons/emotions/sad-active.png',
      'Confused': 'assets/icons/emotions/confused-active.png',
      'Angry': 'assets/icons/emotions/angry-active.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserRepo().getSnapshotsOfUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                ));
          } else if (snapshot.hasError) {
            return Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor),
              child: Center(
                child: Text('Something went wrong'),
              ),
            );
          } else {
            snapshot.data.docs.forEach((user) {
              User pulledUser =
                  User.fromJson(jsonDecode(json.encode(user.data())));
              if (pulledUser.tenantId != "Employer" &&
                  pulledUser.business == business) {
                _employees.add(pulledUser);
              }
            });
            return Container(
                height: MediaQuery.of(context).size.height - 305,
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                    child: Column(
                  children: _employees.map((user) {
                    return FractionallySizedBox(
                      widthFactor: .95,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(4, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 50),
                                child: Text(user.name),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Image.asset(emotions[user.emotion]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )));
          }
        });
  }
}
