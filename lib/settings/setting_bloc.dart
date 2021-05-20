import 'dart:async';

import 'package:chatapp/settings/setting_event.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(SettingState initialState) : super(initialState);

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is SettingEventInProgress) {
      yield SettingState.loading(true);
    } else if (event is SettingErrorEvent) {
      yield SettingState.error(event.error);
    }
  }
}
