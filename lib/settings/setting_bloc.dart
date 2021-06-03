import 'dart:async';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/settings/setting_event.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(SettingState initialState) : super(initialState) {
    _initialize();
  }

  User _currentUser;
  void _initialize() {
    _currentUser = UserRepo().getCurrentUser();
    print("CURENT: ${_currentUser.toJson().toString()}");
  }

  String getUserName() {
    return _currentUser.name;
  }

  void setUserName(String userName) {
    UserRepo().setUserName(userName);
  }

  void setEmail(String email) {
    UserRepo().setEmail(email);
  }

  void setBirthday(String birthday) {
    UserRepo().setBirthday(birthday);
  }

  String getUserEmail() {
    return _currentUser.email;
  }

  String getUserBirthday() {
    return _currentUser.birthday;
  }

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is SettingEventInProgress) {
      yield SettingState.loading(true);
    } else if (event is SettingErrorEvent) {
      yield SettingState.error(event.error);
    }
  }
}
