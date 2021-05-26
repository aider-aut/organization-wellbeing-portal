import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/main/main_bloc.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:chatapp/main/main_state.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key key,
  }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  String currentEmotion;
  var _options;
  String emotion;
  String displayName;
  String happyUrl, sadUrl, confusedUrl, angryUrl;
  @override
  void initState() {
    super.initState();
    emotion = UserRepo().getEmotion();
    displayName = UserRepo().getUserName();
    _options = [true, false, false];
    happyUrl =
        'assets/icons/emotions/${emotion == "Happy" ? "happy-active.png" : "happy.png"}';
    sadUrl =
        'assets/icons/emotions/${emotion == "Sad" ? "sad-active.png" : "sad.png"}';
    confusedUrl =
        'assets/icons/emotions/${emotion == "Confused" ? "confused-active.png" : "confused.png"}';
    angryUrl =
        'assets/icons/emotions/${emotion == "Angry" ? "angry-active.png" : "angry.png"}';
  }

  @override
  Widget build(BuildContext context) {
    void updateEmotions(String value) {
      setState(() {
        UserRepo().setEmotion(value);
        happyUrl =
            'assets/icons/emotions/${value == "Happy" ? "happy-active.png" : "happy.png"}';
        sadUrl =
            'assets/icons/emotions/${value == "Sad" ? "sad-active.png" : "sad.png"}';
        confusedUrl =
            'assets/icons/emotions/${value == "Confused" ? "confused-active.png" : "confused.png"}';
        angryUrl =
            'assets/icons/emotions/${value == "Angry" ? "angry-active.png" : "angry.png"}';
      });
    }

    return Scaffold(
        body: BlocWidget<MainEvent, MainState, MainBloc>(
            builder: (BuildContext context, MainState state) =>
                Scaffold(body: Builder(builder: (BuildContext context) {
                  Widget content;
                  if (state.isLoading) {
                    content = Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                          ),
                        ));
                  } else {
                    content = Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor),
                      child: ListView(
                        children: [
                          Container(
                            child: null,
                            height: 20,
                          ),
                          CircleAvatar(
                            child: new Image.network(
                              state.imageUrls['profile'],
                              height: 70,
                              width: 70,
                            ),
                            radius: 50,
                            backgroundColor: Colors.transparent,
                          ),
                          Center(
                            child: Text(displayName == null ? '' : displayName),
                          ),
                          SizedBox(height: 50),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: Center(
                                        child: InkWell(
                                            child: Text(
                                              "My History",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onTap: () => setState(() {
                                                  _options = [
                                                    true,
                                                    false,
                                                    false
                                                  ];
                                                })))),
                              ),
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: Center(
                                        child: InkWell(
                                            child: Text(
                                              "My Employees",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onTap: () => setState(() {
                                                  _options = [
                                                    false,
                                                    true,
                                                    false
                                                  ];
                                                })))),
                              ),
                              Expanded(
                                  child: Container(
                                      height: 20,
                                      child: Center(
                                          child: InkWell(
                                              child: Text(
                                                "Notifications",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              onTap: () => setState(() {
                                                    _options = [
                                                      false,
                                                      false,
                                                      true
                                                    ];
                                                  }))))),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: Center(
                              child: InkWell(
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: _options[0]
                                            ? Colors.white
                                            : Colors.transparent),
                                  ),
                                  onTap: () => setState(() {
                                        _options = [true, false, false];
                                      })),
                            )),
                            Expanded(
                                child: Center(
                              child: InkWell(
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: _options[1]
                                            ? Colors.white
                                            : Colors.transparent),
                                  ),
                                  onTap: () => setState(() {
                                        _options = [false, true, false];
                                      })),
                            )),
                            Expanded(
                                child: Center(
                              child: InkWell(
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: _options[2]
                                            ? Colors.white
                                            : Colors.transparent),
                                  ),
                                  onTap: () => setState(() {
                                        _options = [false, false, true];
                                      })),
                            )),
                          ]),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(15),
                                child:
                                    new Image.network(state.imageUrls['mood']),
                              ),
                              Text("My Mood")
                            ],
                          ),
                          FractionallySizedBox(
                              widthFactor: 0.95,
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
                                      offset: Offset(
                                          4, 5), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: InkWell(
                                            child: Image.asset(happyUrl),
                                            onTap: () =>
                                                {updateEmotions("Happy")}),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: InkWell(
                                            child: Image.asset(confusedUrl),
                                            onTap: () =>
                                                {updateEmotions("Confused")}),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: InkWell(
                                            child: Image.asset(sadUrl),
                                            onTap: () =>
                                                {updateEmotions("Sad")}),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: InkWell(
                                            child: Image.asset(angryUrl),
                                            onTap: () =>
                                                {updateEmotions("Angry")}),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(15),
                                child: new Image.network(
                                    state.imageUrls['barrier']),
                              ),
                              Text("My Challenges")
                            ],
                          ),
                          FractionallySizedBox(
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
                                    offset: Offset(
                                        4, 5), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("· Depression"),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text("· Drug use"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return content;
                }))));
  }
}
