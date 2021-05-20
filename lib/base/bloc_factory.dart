import 'package:chatapp/create_chatroom/create_chatroom_bloc.dart';
import 'package:chatapp/create_chatroom/create_chatroom_state.dart';
import 'package:chatapp/demographics/demographics_bloc.dart';
import 'package:chatapp/demographics/demographics_state.dart';
import 'package:chatapp/instant_messaging/instant_messaging_bloc.dart';
import 'package:chatapp/instant_messaging/instant_messaging_state.dart';
import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/main/main_bloc.dart';
import 'package:chatapp/main/main_state.dart';
import 'package:chatapp/settings/setting_bloc.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:chatapp/signup/signup_bloc.dart';
import 'package:chatapp/signup/signup_state.dart';
import 'package:chatapp/welcome/welcome_bloc.dart';
import 'package:chatapp/welcome/welcome_state.dart';
import 'package:flutter/services.dart';

abstract class BlocFactory {
  static const error = 'BlocFactoryError';

  static T create<T>(Map<String, dynamic> data) {
    switch (T) {
      case MainBloc:
        return MainBloc(MainState.initial()) as T;
      case LoginBloc:
        return LoginBloc(LoginState.initial()) as T;
      case SignUpBloc:
        return SignUpBloc(SignUpState.initial()) as T;
      case SettingBloc:
        return SettingBloc(SettingState.initial()) as T;
      case DemographicsBloc:
        return DemographicsBloc(DemographicsState.initial()) as T;
      case CreateChatroomBloc:
        return CreateChatroomBloc(CreateChatroomState.initial()) as T;
      case InstantMessagingBloc:
        return InstantMessagingBloc(
            InstantMessagingState.initial(), data['chatroomId']) as T;
      case WelcomeBloc:
        return WelcomeBloc(WelcomeState.initial()) as T;
      default:
        throw new PlatformException(
            code: BlocFactory.error,
            message: 'Requested bloc for unsupported type ${T.runtimeType}');
    }
  }
}
