class SettingState {
  bool loading;
  Map<String, dynamic> error;
  dynamic status;

  SettingState._internal({this.loading, this.error, this.status});

  factory SettingState.initial() => SettingState._internal(loading: false, error:{'code':'', 'message':''}, status: null);

  factory SettingState.loading(bool loading) =>
      SettingState._internal(loading: loading);

  factory SettingState.error(Map<String, dynamic> error) => SettingState._internal(loading: false, error: error, status: null);

  factory SettingState.status(dynamic status) => SettingState._internal(loading: false, error: {'code':'', 'message':''}, status: status);
}
