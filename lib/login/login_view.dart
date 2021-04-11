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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ButtonTheme(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent, // background
                            onPrimary: Colors.white, // foreground
                            padding: EdgeInsets.only(
                                left: 20.0,
                                right: 30.0,
                                top: 10.0,
                                bottom: 10.0)),
                        onPressed: () =>
                            BlocProvider.of<LoginBloc>(context).onLoginGoogle(),
                        child: Text(
                          "Continue with Google",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () => BlocProvider.of<LoginBloc>(context)
                            .onLoginFacebook(),
                        child: Text(
                          "Continue with Facebook",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Text("or"),
                ButtonTheme(
                  child: TextButton(
                    onPressed: () => navigateToSignUp(),
                    child: Text("Sign up",
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                Text("Have an account? "),
                ButtonTheme(
                    child: TextButton(
                        onPressed: () => navigateToLogInWithEmail(),
                        child: new Text("Log in",
                            style: TextStyle(color: Colors.blue))))
              ],
            ),
          );
        }
      }),
    );
  }

  void navigateToMain() {
    NavigationHelper.navigateToMain(context);
  }

  void navigateToSignUp() {
    NavigationHelper.navigateToSignUp(context, addToBackStack: true);
  }

  void navigateToLogInWithEmail() {
    NavigationHelper.navigateToLogInWithEmail(context, addToBackStack: true);
  }
}
