abstract class SignUpEvent {}

class SignUpWithEmailEvent extends SignUpEvent {}

class SignUpEventInProgress extends SignUpEvent {}

class SignUpErrorEvent extends SignUpEvent {
  SignUpErrorEvent(this.error);

  final dynamic error;
}
