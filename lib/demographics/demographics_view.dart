import 'dart:async';

import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/demographics/demographics_bloc.dart';
import 'package:chatapp/demographics/demographics_event.dart';
import 'package:chatapp/demographics/demographics_state.dart';
import 'package:chatapp/demographics/steps/step_1_view.dart';
import 'package:chatapp/demographics/steps/step_2_view.dart';
import 'package:chatapp/demographics/steps/step_3_view.dart';
import 'package:chatapp/demographics/steps/step_4_view.dart';
import 'package:chatapp/demographics/steps/step_5_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemographicScreen extends StatefulWidget {
  DemographicScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DemographicState();
}

class _DemographicState extends State<DemographicScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    void _onNext() {
      setState(() {
        _currentStep++;
      });
    }

    return BlocWidget<DemographicsEvent, DemographicsState, DemographicsBloc>(
      builder: (BuildContext context, DemographicsState state) =>
          Scaffold(body: Builder(builder: (BuildContext context) {
        Widget content;
        if (state.loading) {
          content = Center(
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ),
          );
        } else if (_currentStep == 0) {
          content = Step1Screen(onNext: _onNext);
        } else if (_currentStep == 1) {
          content = Step2Screen(onNext: _onNext);
        } else if (_currentStep == 2) {
          content = Step3Screen(onNext: _onNext);
        } else if (_currentStep == 3) {
          content = Step4Screen(onNext: _onNext);
        } else if (_currentStep == 4) {
          content = Step5Screen(onNext: _onNext);
        }
        return content;
      })),
    );
  }
}
