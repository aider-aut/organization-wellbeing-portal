import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/base/bloc_widget.dart';

import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/navigation_helper.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: BlocWidget<LoginEvent, LoginState, LoginBloc>(
        builder: (BuildContext context, LoginState state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator(strokeWidth: 4.0));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 256.0,
                    height: 32.0,
                    child: RaisedButton(
                      onPressed: () =>
                          BlocProvider.of<LoginBloc>(context).onLoginGoogle(),
                      child: Text(
                        "Continue with Google",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.redAccent,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 256.0,
                    height: 32.0,
                    child: RaisedButton(
                      onPressed: () =>
                          BlocProvider.of<LoginBloc>(context).onLoginFacebook(),
                      child: Text(
                        "Continue with Facebook",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text("or"),
                  ButtonTheme(
                    minWidth: 256.0,
                    height: 32.0,
                    child: RaisedButton(
                        onPressed: () => navigateToSignUp(),
                        child: Text("Sign up",
                            style: TextStyle(color: Colors.black)),
                        color: Colors.white10),
                  ),
                  Text("Have an account? "),
                  new FlatButton(
                      onPressed: () => navigateToLogInWithEmail(),
                      child: new Text("Log in",
                          style: TextStyle(color: Colors.blue)))
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void navigateToMain() {
    NavigationHelper.navigateToMain(context);
  }

  void navigateToSignUp() {
    NavigationHelper.navigateToSignUp(context);
  }

  void navigateToLogInWithEmail() {
    NavigationHelper.navigateToLogInWithEmail(context);
  }
}
