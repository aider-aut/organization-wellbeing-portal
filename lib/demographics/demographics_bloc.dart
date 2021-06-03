import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/demographics/demographics_event.dart';
import 'package:chatapp/demographics/demographics_state.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';

class DemographicsBloc extends Bloc<DemographicsEvent, DemographicsState> {
  DemographicsBloc(DemographicsState initialState) : super(initialState) {
    _initialize();
  }
  Map<String, dynamic> _data = {};
  User _currentUser;

  void _initialize() {
    _currentUser = UserRepo().getCurrentUser();
  }

  void submitData(Map<String, dynamic> newData) {
    add(DemographicsEventInProgress());
    _data.addAll(newData);
    if (_data.keys.length == 5) {
      UserRepo().setTenant(_data['tenant']);
      UserRepo().setBusiness(_data['business']);
      UserRepo().setEmotion(_data['emotion']);
      UserRepo().setBusinessWellbeing(_data['wellbeing'].toString());
      UserRepo().setSource(_data['heardFrom']);
    }
    add(DemographicsEventFinished());
  }

  @override
  Stream<DemographicsState> mapEventToState(DemographicsEvent event) async* {
    if (event is DemographicsEventInProgress) {
      yield DemographicsState.loading(true);
    } else if (event is DemographicsEventFinished) {
      yield DemographicsState.loading(false);
    }
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
