abstract class DemographicsEvent {}

class DemographicsEventInProgress extends DemographicsEvent {}

class DemographicsEventFinished extends DemographicsEvent {}

class DemographicsErrorEvent extends DemographicsEvent {
  DemographicsErrorEvent(this.error);

  final dynamic error;
}
