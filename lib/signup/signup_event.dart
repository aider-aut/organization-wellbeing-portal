abstract class SignUpEvent {}

class SignUpEventInProgress extends SignUpEvent {}

class SignUpSuccessEvent extends SignUpEvent {}

class SignUpStatusUpdate extends SignUpEvent {
  SignUpStatusUpdate(this.status);

  final dynamic status;
}

class SignUpErrorEvent extends SignUpEvent {
  SignUpErrorEvent(this.error);

  final dynamic error;
}
