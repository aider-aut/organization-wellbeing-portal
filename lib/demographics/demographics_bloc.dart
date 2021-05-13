import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chatapp/demographics/demographics_event.dart';
import 'package:chatapp/demographics/demographics_state.dart';

class DemographicsBloc
    extends Bloc<DemographicsEvent, DemographicsState> {

  DemographicsBloc(DemographicsState initialState) : super(initialState) {
  }

  @override
  Stream<DemographicsState> mapEventToState(
      DemographicsEvent event) async* {
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
