import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocWidget<LoginEvent, LoginState, LoginBloc>(
          builder: (BuildContext context, LoginState state) {
        if (state.loading) {
          return Center(child: CircularProgressIndicator(strokeWidth: 4.0));
        } else {
          return SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/bot.png'),
                          Center(
                            child: Text(
                              'Aider Wellbeing \nAssistant',
                              style: TextStyle(
                                  fontSize: 29, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Artificial Intelligence for your \nWellbeing.',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 100),
                          ButtonTheme(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent, // background
                                  onPrimary: Colors.white, // foreground
                                  padding: EdgeInsets.only(
                                      left: 54.0,
                                      right: 54.0,
                                      top: 10.0,
                                      bottom: 10.0)),
                              onPressed: () =>
                                  BlocProvider.of<LoginBloc>(context)
                                      .onLoginGoogle(),
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
                                  padding: EdgeInsets.only(
                                      left: 45.0,
                                      right: 45.0,
                                      top: 10.0,
                                      bottom: 10.0)),
                              onPressed: () =>
                                  BlocProvider.of<LoginBloc>(context)
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, // background
                              onPrimary: Colors.white, // foreground
                              padding: EdgeInsets.only(
                                  left: 64.0,
                                  right: 64.0,
                                  top: 10.0,
                                  bottom: 10.0)),
                          onPressed: () => navigateToSignUp(),
                          child: Text("Sign up with Email",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 110),
                          child: Row(
                            children: [
                              Text("Already have an account? "),
                              ButtonTheme(
                                  child: TextButton(
                                      onPressed: () =>
                                          navigateToLogInWithEmail(),
                                      child: new Text("Log in",
                                          style: TextStyle(
                                              color: Color(0Xff365E7D)))))
                            ],
                          ))
                    ],
                  ),
                )),
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
