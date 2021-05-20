abstract class WelcomeEvent {}

class WelcomeEventInProgress extends WelcomeEvent {}

class WelcomeStatusUpdate extends WelcomeEvent {
  WelcomeStatusUpdate(this.status);

  final dynamic status;
}

class WelcomeErrorEvent extends WelcomeEvent {
  WelcomeErrorEvent(this.error);

  final dynamic error;
}
