import 'dart:async';

import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/main/main_bloc.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:chatapp/main/main_state.dart';
import 'package:chatapp/main/screens/business_view.dart';
import 'package:chatapp/main/screens/employees_view.dart';
import 'package:chatapp/main/screens/wellbeing_view.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key key,
  }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<User> _employees;
  String _business;
  List<String> _challenges;
  Map<String, bool> _options;
  String displayName;
  bool isEmployer = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    Timer(Duration(milliseconds: 200), () => _controller.forward());
    displayName = UserRepo().getUserName();
    _options = {'history': true, 'employees': false, 'business': false};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocWidget<MainEvent, MainState, MainBloc>(
            builder: (BuildContext context, MainState state) =>
                Scaffold(body: Builder(
                    // stream: UserRepo().getEmployees(),
                    builder: (BuildContext context) {
                  _challenges =
                      BlocProvider.of<MainBloc>(context).getMyChallenges();
                  isEmployer =
                      BlocProvider.of<MainBloc>(context).isUserEmployer();
                  if (isEmployer) {
                    _employees =
                        BlocProvider.of<MainBloc>(context).getEmployees();
                    _business =
                        BlocProvider.of<MainBloc>(context).getBusiness();
                  }

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
                    Widget _currentOption;
                    if (_options['history']) {
                      _currentOption = SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(_controller),
                          child: FadeTransition(
                              opacity: _controller,
                              child: WellbeingScreen(
                                  challenges: _challenges,
                                  imgUrls: state.imageUrls)));
                    } else if (_options['employees']) {
                      _currentOption = SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(_controller),
                          child: FadeTransition(
                              opacity: _controller,
                              child: EmployeeScreen(business: _business)));
                    } else {
                      _currentOption = SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(-1, 0),
                            end: Offset.zero,
                          ).animate(_controller),
                          child: FadeTransition(
                              opacity: _controller,
                              child: BusinessScreen(business: _business)));
                    }
                    content = Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor),
                        child: ListView(children: [
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
                                                  _options['history'] = true;
                                                  _options['employees'] = false;
                                                  _options['business'] = false;
                                                })))),
                              ),
                              isEmployer
                                  ? Expanded(
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
                                                        _options['history'] =
                                                            false;
                                                        _options['employees'] =
                                                            true;
                                                        _options['business'] =
                                                            false;
                                                      })))),
                                    )
                                  : SizedBox(),
                              isEmployer
                                  ? Expanded(
                                      child: Container(
                                          height: 20,
                                          child: Center(
                                              child: InkWell(
                                                  child: Text(
                                                    "My Business",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onTap: () => setState(() {
                                                        _options['history'] =
                                                            false;
                                                        _options['employees'] =
                                                            false;
                                                        _options['business'] =
                                                            true;
                                                      })))))
                                  : SizedBox()
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
                                        color: _options['history']
                                            ? Colors.white
                                            : Colors.transparent),
                                  ),
                                  onTap: () => setState(() {
                                        _options['history'] = true;
                                        _options['employees'] = false;
                                        _options['business'] = false;
                                      })),
                            )),
                            isEmployer
                                ? Expanded(
                                    child: Center(
                                    child: InkWell(
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: _options['employees']
                                                  ? Colors.white
                                                  : Colors.transparent),
                                        ),
                                        onTap: () => setState(() {
                                              _options['history'] = false;
                                              _options['employees'] = true;
                                              _options['business'] = false;
                                            })),
                                  ))
                                : SizedBox(),
                            isEmployer
                                ? Expanded(
                                    child: Center(
                                    child: InkWell(
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: _options['business']
                                                  ? Colors.white
                                                  : Colors.transparent),
                                        ),
                                        onTap: () => setState(() {
                                              _options['history'] = false;
                                              _options['employees'] = false;
                                              _options['business'] = true;
                                            })),
                                  ))
                                : SizedBox(),
                          ]),
                          SizedBox(height: 20),
                          _currentOption,
                        ]));
                  }
                  return content;
                }))));
  }
}
