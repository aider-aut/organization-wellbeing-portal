import 'dart:async';

import 'package:chatapp/welcome/welcome_event.dart';
import 'package:chatapp/welcome/welcome_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc(WelcomeState initialState) : super(initialState);

  @override
  Stream<WelcomeState> mapEventToState(WelcomeEvent event) async* {
    if (event is WelcomeEventInProgress) {
      yield WelcomeState.loading(true);
    } else if (event is WelcomeStatusUpdate) {
      yield WelcomeState.status(event.status);
    } else if (event is WelcomeErrorEvent) {
      yield WelcomeState.error(event.error);
    }
  }
}
