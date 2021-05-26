import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
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
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
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
                return Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    )));
              } else {
                return SingleChildScrollView(
                    child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).backgroundColor),
                  child: Column(children: [
                    SizedBox(height: 40),
                    Image.asset("assets/auth-image.png"),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      padding:
                          EdgeInsetsDirectional.only(start: 40.0, end: 40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFF4F9FE)),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Email",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF3E4347),
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
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
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 15.0),
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFF4F9FE)),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text("Password",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF3E4347),
                                          ),
                                          textAlign: TextAlign.center),
                                    ),
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
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    Positioned(
                                        left:
                                            (MediaQuery.of(context).size.width -
                                                150.0),
                                        child: TextButton(
                                            onPressed: _toggle,
                                            child: new Text(_obscureText
                                                ? "Show"
                                                : "Hide")))
                                  ],
                                )),
                            SizedBox(height: 15.0),
                            Center(
                                child: Container(
                                    width: 400,
                                    height: 50,
                                    child: ButtonTheme(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            final form = _formKey.currentState;
                                            if (form.validate()) {
                                              form.save();
                                              BlocProvider.of<LoginBloc>(
                                                      context)
                                                  .onLoginWithEmail(_email,
                                                      _password, context);
                                            }
                                          },
                                          child: Text("Log in",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                              // background
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)))),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ]),
                ));
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
