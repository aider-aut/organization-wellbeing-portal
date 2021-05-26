import 'dart:async';

import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:flutter/material.dart';

class Step5Screen extends StatefulWidget {
  Step5Screen({Key key, @required this.onNext}) : super(key: key);
  final Function onNext;

  @override
  State<StatefulWidget> createState() => _Step5State();
}

class _Step5State extends State<Step5Screen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    Timer(Duration(milliseconds: 200), () => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 40, right: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                LinearProgressIndicator(
                  value: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0Xff855CF8)),
                  backgroundColor: Colors.white,
                  semanticsLabel: 'Linear progress indicator',
                ),
                Expanded(
                    child: Container(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(_controller),
                        child: FadeTransition(
                            opacity: _controller,
                            child: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text('Thank you!',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))))),
                    SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(_controller),
                        child: FadeTransition(
                            opacity: _controller,
                            child: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    child: Text("Get started"),
                                    onPressed: () {
                                      UserRepo().setFirstUser(false);
                                      navigateToIndex();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color(0xff5DB075), // background
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))))))),
                  ],
                )))
              ]),
        ));
  }

  void navigateToIndex() {
    NavigationHelper.navigateToIndex(context);
  }
}
