import 'dart:async';

import 'package:chatapp/demographics/demographics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step2Screen extends StatefulWidget {
  Step2Screen({Key key, @required this.onNext}) : super(key: key);
  final Function onNext;

  @override
  State<StatefulWidget> createState() => _Step2State();
}

class _Step2State extends State<Step2Screen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Map<String, bool> _options = {'Employer': false, 'Employee': false};
  final _formKey = new GlobalKey<FormState>();
  String _business;

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
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50, left: 40, right: 40),
            child: LinearProgressIndicator(
              value: 0.2,
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
                      child: Text('Are you an..',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold))))),
          SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-1, 0),
                end: Offset.zero,
              ).animate(_controller),
              child: FadeTransition(
                  opacity: _controller,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () => setState(() {
                                        final active = !_options['Employer'];
                                        _options = {
                                          'Employer': active,
                                          'Employee': false
                                        };
                                      }),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 50),
                                            child: Checkbox(
                                              activeColor: Colors.lightGreen,
                                              value: this._options['Employer'],
                                              onChanged: (bool value) {
                                                setState(() {
                                                  final active =
                                                      !_options['Employer'];
                                                  _options = {
                                                    'Employer': active,
                                                    'Employee': false
                                                  };
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 40),
                                              child: Image.asset(
                                                  'assets/employer.png',
                                                  width: 100,
                                                  height: 100))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text("Employer")
                                ],
                              )),
                          Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () => setState(() {
                                        final active = !_options['Employee'];
                                        _options = {
                                          'Employer': false,
                                          'Employee': active
                                        };
                                      }),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 50),
                                            child: Checkbox(
                                              activeColor: Colors.lightGreen,
                                              value: this._options['Employee'],
                                              onChanged: (bool value) {
                                                setState(() {
                                                  final active =
                                                      !_options['Employee'];
                                                  _options = {
                                                    'Employer': false,
                                                    'Employee': active
                                                  };
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 40),
                                              child: Image.asset(
                                                  'assets/employee.png',
                                                  width: 100,
                                                  height: 100))
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ),
                                  Text("Employee")
                                ],
                              )),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('What is the name of your business?',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          width: MediaQuery.of(context).size.width / 4,
                          height: 40,
                          child: TextFormField(
                            // textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                                helperText: ' ',
                                contentPadding: const EdgeInsets.only(
                                  left: 10.0,
                                  // top: 10,
                                  bottom: 5.0,
                                ),
                                hintText: "Business",
                                border: InputBorder.none),
                            autofocus: false,
                            validator: (String value) {
                              bool valueValid =
                                  value.isNotEmpty && value.trim().isNotEmpty;
                              return (valueValid)
                                  ? null
                                  : "This field cannot be empty";
                            },
                            onChanged: (String value) => setState(() {
                              _business = value;
                            }),
                          ))
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
                          padding: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                              child: Text("Next",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (form.validate() &&
                                    this
                                        ._options
                                        .values
                                        .any((element) => element)) {
                                  this._options.forEach((key, value) {
                                    if (value) {
                                      final newData = {
                                        'tenant': key,
                                        'business': _business
                                      };

                                      BlocProvider.of<DemographicsBloc>(context)
                                          .submitData(newData);
                                      widget.onNext();
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  // background
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))))))),
        ]),
      )),
    );
  }
}
