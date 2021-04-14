
class LoginState {
  bool loading;
  Map<String, dynamic> error;

  LoginState._internal({this.loading, this.error});

  factory LoginState.initial() => LoginState._internal(loading: false, error: {'code': '', 'message':''});

  factory LoginState.loading(bool loading) =>
      LoginState._internal(loading: loading);

  factory LoginState.error(Map<String, dynamic> error) => LoginState._internal(loading: false, error: error);
}
