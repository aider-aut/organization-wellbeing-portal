import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginEmailScreen extends StatefulWidget {
  LoginEmailScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmailScreen> {
  final _formKey = new GlobalKey<FormState>();
  String _email, _password;
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Login with Email")),
            body: BlocWidget<LoginEvent, LoginState, LoginBloc>(
                builder: (BuildContext context, LoginState state) {
              if (state.error != null && state.error['message'].isNotEmpty) {
                return AlertDialog(
                  title: Text("Login Failure"),
                  content: Text(state.error['message']),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        if (state.error['code'] == "user-not-found") {
                          navigateToSignUp();
                        } else {
                          navigateToLogInWithEmail();
                        }
                      },
                    ),
                  ],
                );
              } else if (state.loading) {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ));
              } else {
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsetsDirectional.only(start: 40.0, end: 40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              autofocus: false,
                              validator: (String value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                return (emailValid)
                                    ? null
                                    : "Please enter valid email";
                              },
                              onSaved: (String value) {
                                _email = value;
                              },
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.email), hintText: "Email"),
                            ),
                            SizedBox(height: 15.0),
                            Stack(
                              children: <Widget>[
                                TextFormField(
                                  autofocus: false,
                                  validator: (val) => val.length < 6
                                      ? 'Password too short (it has to be longer than 6 characters).'
                                      : null,
                                  onSaved: (String value) {
                                    _password = value;
                                  },
                                  obscureText: _obscureText,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.lock),
                                      hintText: "Password"),
                                ),
                                Positioned(
                                    left: (MediaQuery.of(context).size.width -
                                        150.0),
                                    child: TextButton(
                                        onPressed: _toggle,
                                        child: new Text(
                                            _obscureText ? "Show" : "Hide")))
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Center(
                                child: ButtonTheme(
                              minWidth: 256.0,
                              height: 32.0,
                              child: ElevatedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      BlocProvider.of<LoginBloc>(context)
                                          .onLoginWithEmail(_email, _password);
                                      bool _isFirstUser = false;
                                      bool _isEmailVerified = false;
                                      UserRepo.getInstance()
                                          .isFirstUser()
                                          .then((value) {
                                        _isFirstUser = value;
                                      });
                                      UserRepo.getInstance()
                                          .isEmailVerified()
                                          .then((value) {
                                        _isEmailVerified = value;
                                      });

                                      if (_isFirstUser || !_isEmailVerified) {
                                        NavigationHelper.navigateToWelcome(
                                            context,
                                            addToBackStack: false);
                                      } else {
                                        NavigationHelper.navigateToMain(context,
                                            addToBackStack: false);
                                      }
                                    }
                                  },
                                  child: Text("Sign in",
                                      style: TextStyle(color: Colors.black)),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white10)),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            })));
  }

  void navigateToSignUp() {
    NavigationHelper.navigateToSignUp(context, addToBackStack: false);
  }

  void navigateToLogInWithEmail() {
    NavigationHelper.navigateToLogInWithEmail(context, addToBackStack: false);
  }
}
