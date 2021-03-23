class SignUpState {
  bool loading;

  SignUpState._internal({this.loading});

  factory SignUpState.initial() => SignUpState._internal(loading: false);

  factory SignUpState.loading(bool loading) =>
      SignUpState._internal(loading: loading);
}
