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

  void _initialize() async {
    _currentUser = await UserRepo.getInstance().getCurrentUser();
  }

  void submitData(Map<String, dynamic> newData) {
    _data.addAll(newData);
    if (_data.keys.length == 4) {
      UserRepo.getInstance().setTenant(_data['tenant']);
      UserRepo.getInstance().setEmotion(_data['emotion'], update: false);
      UserRepo.getInstance()
          .setBusinessWellbeing(_data['wellbeing'].toString());
      UserRepo.getInstance().setSource(_data['heardFrom']);
    }
    print("data: ${_data}");
  }

  @override
  Stream<DemographicsState> mapEventToState(DemographicsEvent event) async* {
    if (event is DemographicsEventInProgress) {
      yield DemographicsState.loading(true);
    }
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
