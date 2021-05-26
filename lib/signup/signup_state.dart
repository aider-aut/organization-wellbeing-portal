class SignUpState {
  bool loading;
  Map<String, dynamic> error;
  dynamic status;

  SignUpState._internal({this.loading, this.error, this.status});

  factory SignUpState.initial() => SignUpState._internal(
      loading: false, error: {'code': '', 'message': ''}, status: null);

  factory SignUpState.loading(bool loading) =>
      SignUpState._internal(loading: loading, error: {}, status: null);

  factory SignUpState.error(Map<String, dynamic> error) =>
      SignUpState._internal(loading: false, error: error, status: null);

  factory SignUpState.status(dynamic status) => SignUpState._internal(
      loading: false, error: {'code': '', 'message': ''}, status: status);
}
