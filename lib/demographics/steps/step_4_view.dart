import 'dart:async';

import 'package:chatapp/demographics/demographics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step4Screen extends StatefulWidget {
  Step4Screen({Key key, @required this.onNext}) : super(key: key);
  final Function onNext;

  @override
  State<StatefulWidget> createState() => _Step4State();
}

class _Step4State extends State<Step4Screen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String _emotion;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    Timer(Duration(milliseconds: 200), () => _controller.forward());
    _emotion = "Happy";
  }

  @override
  Widget build(BuildContext context) {
    String happyUrl =
        'assets/icons/emotions/${_emotion == "Happy" ? "happy-active.png" : "happy.png"}';
    String sadUrl =
        'assets/icons/emotions/${_emotion == "Sad" ? "sad-active.png" : "sad.png"}';
    String confusedUrl =
        'assets/icons/emotions/${_emotion == "Confused" ? "confused-active.png" : "confused.png"}';
    String angryUrl =
        'assets/icons/emotions/${_emotion == "Angry" ? "angry-active.png" : "angry.png"}';
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 50, left: 40, right: 40),
          child: LinearProgressIndicator(
            value: 0.6,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0Xff855CF8)),
            backgroundColor: Colors.white,
            semanticsLabel: 'Linear progress indicator',
          ),
        ),
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
                    child: Column(
                      children: [
                        Text('How are you doing?',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
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
                            children: [
                              Expanded(
                                child: Container(
                                  child: InkWell(
                                      child: Image.asset(happyUrl),
                                      onTap: () => {
                                            setState(() {
                                              _emotion = "Happy";
                                            })
                                          }),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: InkWell(
                                      child: Image.asset(confusedUrl),
                                      onTap: () => setState(() {
                                            _emotion = "Confused";
                                          })),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: InkWell(
                                      child: Image.asset(sadUrl),
                                      onTap: () => setState(() {
                                            _emotion = "Sad";
                                          })),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: InkWell(
                                      child: Image.asset(angryUrl),
                                      onTap: () => setState(() {
                                            _emotion = "Angry";
                                          })),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )))),
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
                    child: Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: ElevatedButton(
                            child: Text("Next"),
                            onPressed: () {
                              final newData = {'emotion': _emotion};
                              BlocProvider.of<DemographicsBloc>(context)
                                  .submitData(newData);
                              widget.onNext();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue, // background
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15)))))))),
      ]),
    );
  }
}
