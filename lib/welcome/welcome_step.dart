import 'dart:async';

import 'package:chatapp/navigation_helper.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

class WelcomeStepScreen extends StatefulWidget {
  WelcomeStepScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<WelcomeStepScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    Timer(Duration(milliseconds: 200), () => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        Widget content;
        if (_currentIndex == 0) {
          content = SwipeDetector(
            onSwipeLeft: () {
              setState(() {
                _currentIndex += 1;
              });
            },
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 60, right: 20),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => _currentIndex = 3,
                          child: Text(
                            'Skip intro',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 120)),
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
                                child: Image.asset('assets/bot.png')))),
                    SizedBox(height: 10),
                    SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(_controller),
                        child: FadeTransition(
                            opacity: _controller,
                            child: Text('Welcome to Aider',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)))),
                    SizedBox(height: 40),
                    SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(_controller),
                        child: FadeTransition(
                            opacity: _controller,
                            child: Text(
                              "AWA is your personal mood tracker\nthat helps you monitor your wellbeing\nby making it a priority. ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))),
                  ]),
            ),
            );
        } else if (_currentIndex == 1) {
          content = SwipeDetector(
              onSwipeLeft: () {
                setState(() {
                  _currentIndex += 1;
                });
              },
              onSwipeRight: (){
                setState((){
                  _currentIndex -= 1;
                });
              },
              child: Container(
            decoration: BoxDecoration(color: Color(0x5cC4C4C4)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 60, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Skip intro',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 120)),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: Container(
                              width: 300,
                              height: 300,
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Image.asset(
                                  'assets/welcome-step-2-image.png')))),
                  SizedBox(height: 40),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: Text(
                            "It is easy to forget to take care of yourself\nwhile working. AWA will not only remind you\nto do so, but also keep track of your habits?",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))),
                ]),
          ));
        } else if (_currentIndex == 2) {
          content = SwipeDetector(
              onSwipeLeft: () {
                setState(() {
                  _currentIndex += 1;
                });
              },
              onSwipeRight: (){
                setState((){
                  _currentIndex -= 1;
                });
              },
              child: Container(
            decoration: BoxDecoration(color: Color(0x5cC4C4C4)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 60, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Skip intro',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 120)),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: Container(
                              width: 300,
                              height: 300,
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Image.asset(
                                  'assets/welcome-step-3-image.png')))),
                  SizedBox(height: 40),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: Text(
                            "Your work life has a big impact on your\npersonal life. Monitor your stress levels\nin and out of work to uncover why and take\nback control!",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))),
                ]),
          ));
        } else if (_currentIndex == 3) {
          content = SwipeDetector(
              onSwipeLeft: () {
              navigateToDemographics();
          },
              onSwipeRight: (){
                setState((){
                  _currentIndex -= 1;
                });
              },
        child: Container(
            decoration: BoxDecoration(color: Color(0x5cC4C4C4)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 60, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Skip intro',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 120)),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: Container(
                              width: 300,
                              height: 300,
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Image.asset(
                                  'assets/welcome-get-started-image.png')))),
                  SizedBox(height: 40),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: Text(
                            "Get an overview of how you’re doing and set\ngoals to acheive even more. ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))),
                  SizedBox(height: 40),
                  SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1, 0),
                        end: Offset.zero,
                      ).animate(_controller),
                      child: FadeTransition(
                          opacity: _controller,
                          child: ElevatedButton(
                              child: Text("Get started"),
                              onPressed: () {
                                navigateToDemographics();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xff5DB075), // background
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))))),
                ]),
          ));
        }
        return content;
      }),
      bottomNavigationBar: SizedBox(
          height: 50,
          child: DotsIndicator(
              dotsCount: 4,
              position: _currentIndex,
              decorator: DotsDecorator(
                color: Color(0xffC4C4C4), // Inactive color
                activeColor: Color(0Xff5B5B64),
              ),
              onTap: (position) {
                setState(() => _currentIndex = position);
              })),
    );
  }
  void navigateToDemographics() {
    NavigationHelper.navigateToDemographics(context, addToBackStack: false);
  }
}
