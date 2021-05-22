class WelcomeState {
  bool loading;
  bool isEmailVerified;
  Map<String, dynamic> error;
  dynamic status;

  WelcomeState._internal(
      {this.loading, this.error, this.status, this.isEmailVerified});

  factory WelcomeState.initial() => WelcomeState._internal(
      loading: false, error: {'code': '', 'message': ''}, status: null);

  factory WelcomeState.loading(bool loading) =>
      WelcomeState._internal(loading: loading);

  factory WelcomeState.error(Map<String, dynamic> error) =>
      WelcomeState._internal(loading: false, error: error, status: null);

  factory WelcomeState.status(dynamic status) => WelcomeState._internal(
      loading: false, error: {'code': '', 'message': ''}, status: status);
}
