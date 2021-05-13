class DemographicsState {
  bool loading;
  Map<String, dynamic> error;

  DemographicsState._internal({this.loading, this.error});

  factory DemographicsState.initial() => DemographicsState._internal(loading: false, error: {'code': '', 'message':''});

  factory DemographicsState.loading(bool loading) =>
      DemographicsState._internal(loading: loading);

  factory DemographicsState.error(Map<String, dynamic> error) => DemographicsState._internal(loading: false, error: error);
}