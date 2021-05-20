abstract class SettingEvent {}

class SettingEventInProgress extends SettingEvent {}

class SettingStatusUpdate extends SettingEvent {
  SettingStatusUpdate(this.status);

  final dynamic status;
}

class SettingErrorEvent extends SettingEvent {
  SettingErrorEvent(this.error);

  final dynamic error;
}
