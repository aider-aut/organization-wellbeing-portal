import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LoginState extends Equatable {
  bool loading;

  @override
  List<Object> get props => [];

  LoginState._internal({this.loading});

  factory LoginState.initial() => LoginState._internal(loading: false);

  factory LoginState.loading(bool loading) =>
      LoginState._internal(loading: loading);
}
