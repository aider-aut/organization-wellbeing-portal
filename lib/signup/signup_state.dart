class SignUpState {
  bool loading;
  Map<String, dynamic> error;

  SignUpState._internal({this.loading, this.error});

  factory SignUpState.initial() => SignUpState._internal(loading: false, error:{'code':'', 'message':''});

  factory SignUpState.loading(bool loading) =>
      SignUpState._internal(loading: loading);

  factory SignUpState.error(Map<String, dynamic> error) => SignUpState._internal(error: error);
}
