import 'dart:async';

import 'package:chatapp/demographics/demographics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step3Screen extends StatefulWidget {
  Step3Screen({Key key, @required this.onNext}) : super(key: key);
  final Function onNext;

  @override
  State<StatefulWidget> createState() => _Step3State();
}

class _Step3State extends State<Step3Screen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _currentSliderValue = 0;

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
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.only(top: 50, left: 40, right: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                LinearProgressIndicator(
                  value: 0.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0Xff855CF8)),
                  backgroundColor: Colors.white,
                  semanticsLabel: 'Linear progress indicator',
                ),
                SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(_controller),
                    child: FadeTransition(
                        opacity: _controller,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Text('What is your business wellbeing?',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                            Slider(
                              activeColor: _currentSliderValue < 50
                                  ? Color(0xffFF4B3E)
                                  : _currentSliderValue == 50
                                      ? Color(0xffFFE548)
                                      : Color(0xff5DB075),
                              value: _currentSliderValue,
                              min: 0,
                              max: 100,
                              divisions: 4,
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                });
                              },
                            ),
                            Row(
                              children: [
                                Text("Not well"),
                                Padding(
                                    padding: EdgeInsets.only(left: 60),
                                    child: Text("Mediocre")),
                                Padding(
                                    padding: EdgeInsets.only(left: 70),
                                    child: Text("Great"))
                              ],
                            )
                          ],
                        ))),
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
                                padding: EdgeInsets.only(top: 130),
                                child: ElevatedButton(
                                    child: Text("Next"),
                                    onPressed: () {
                                      final data = {
                                        "wellbeing": _currentSliderValue
                                      };
                                      BlocProvider.of<DemographicsBloc>(context)
                                          .submitData(data);
                                      widget.onNext();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue, // background
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15)))))))),
              ]),
        ));
  }
}
