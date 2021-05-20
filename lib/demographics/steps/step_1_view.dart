import 'dart:async';

import 'package:chatapp/demographics/demographics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step1Screen extends StatefulWidget {
  Step1Screen({Key key, @required this.onNext}) : super(key: key);
  final Function onNext;

  @override
  State<StatefulWidget> createState() => _Step1State();
}

class _Step1State extends State<Step1Screen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Map<String, bool> _sources = {
    'Google': false,
    'SocialMedia': false,
    'Relatives': false,
    'Other': false
  };
  bool _autoValidate;
  String _otherSource;
  String _inputError;

  final _formKey = GlobalKey<FormState>();

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
        height: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 50, left: 40, right: 40),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      LinearProgressIndicator(
                        value: 0,
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
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    Text('How did you hear about us?',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          activeColor: Colors.lightGreen,
                                          value: this._sources['Google'],
                                          onChanged: (bool value) {
                                            setState(() {
                                              bool option =
                                                  !this._sources['Google'];
                                              this._sources = {
                                                'Google': option,
                                                'SocialMedia': false,
                                                'Relatives': false,
                                                'Other': false
                                              };
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text('Google',
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                          onTap: () => setState(() {
                                            bool option =
                                                !this._sources['Google'];
                                            this._sources = {
                                              'Google': option,
                                              'SocialMedia': false,
                                              'Relatives': false,
                                              'Other': false
                                            };
                                          }),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          activeColor: Colors.lightGreen,
                                          value: this._sources['SocialMedia'],
                                          onChanged: (bool value) {
                                            setState(() {
                                              bool option =
                                                  !this._sources['SocialMedia'];
                                              this._sources = {
                                                'Google': false,
                                                'SocialMedia': option,
                                                'Relatives': false,
                                                'Other': false
                                              };
                                            });
                                          },
                                        ),
                                        InkWell(
                                            child: Text('Social Media',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                            onTap: () => setState(() {
                                                  bool option = !this
                                                      ._sources['SocialMedia'];
                                                  this._sources = {
                                                    'Google': false,
                                                    'SocialMedia': option,
                                                    'Relatives': false,
                                                    'Other': false
                                                  };
                                                })),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          activeColor: Colors.lightGreen,
                                          value: this._sources['Relatives'],
                                          onChanged: (bool value) {
                                            setState(() {
                                              bool option =
                                                  !this._sources['Relatives'];
                                              this._sources = {
                                                'Google': false,
                                                'SocialMedia': false,
                                                'Relatives': option,
                                                'Other': false
                                              };
                                            });
                                          },
                                        ),
                                        InkWell(
                                            child: Text('Friends and Family',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                            onTap: () => setState(() {
                                                  bool option = !this
                                                      ._sources['Relatives'];
                                                  this._sources = {
                                                    'Google': false,
                                                    'SocialMedia': false,
                                                    'Relatives': option,
                                                    'Other': false
                                                  };
                                                })),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          activeColor: Colors.lightGreen,
                                          value: this._sources['Other'],
                                          onChanged: (bool value) {
                                            setState(() {
                                              bool option =
                                                  !this._sources['Other'];
                                              this._sources = {
                                                'Google': false,
                                                'SocialMedia': false,
                                                'Relatives': false,
                                                'Other': option
                                              };
                                            });
                                          },
                                        ),
                                        InkWell(
                                            child: Text('Other',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                )),
                                            onTap: () => setState(() {
                                                  bool option =
                                                      !this._sources['Other'];
                                                  this._sources = {
                                                    'Google': false,
                                                    'SocialMedia': false,
                                                    'Relatives': false,
                                                    'Other': option
                                                  };
                                                })),
                                      ],
                                    ),
                                    this._sources["Other"]
                                        ? SizedBox(
                                            width: 220,
                                            height: 60,
                                            child: TextFormField(
                                              style: TextStyle(fontSize: 16.0),
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  helperText: ' ',
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    left: 10.0,
                                                    bottom: 10.0,
                                                  ),
                                                  hintText: "Other",
                                                  border: InputBorder.none),
                                              autofocus: false,
                                              validator: (String value) {
                                                bool valueValid =
                                                    value.isNotEmpty &&
                                                        value.trim().isNotEmpty;
                                                return (valueValid)
                                                    ? null
                                                    : "This field cannot be empty";
                                              },
                                              onSaved: (String value) {
                                                _otherSource = value;
                                              },
                                            ))
                                        : SizedBox()
                                  ],
                                ),
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
                                  child: ElevatedButton(
                                      child: Text("Next"),
                                      onPressed: () {
                                        if (this
                                            ._sources
                                            .values
                                            .any((element) => element)) {
                                          if (_formKey.currentState
                                              .validate()) {
                                            this._sources.forEach((k, v) {
                                              if (v) {
                                                final newData = {
                                                  'heardFrom': k
                                                };
                                                BlocProvider.of<
                                                            DemographicsBloc>(
                                                        context)
                                                    .submitData(newData);
                                              }
                                            });
                                            widget.onNext();
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue, // background
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15))))))),
                    ]),
              )),
        ));
  }
}
