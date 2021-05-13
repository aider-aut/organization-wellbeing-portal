import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/signup/signup_bloc.dart';
import 'package:chatapp/signup/signup_event.dart';
import 'package:chatapp/signup/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final _formKey = new GlobalKey<FormState>();
  String _email, _password, _name;
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
            appBar: AppBar(title: Text("Sign Up")),
            body: BlocWidget<SignUpEvent, SignUpState, SignUpBloc>(
                builder: (BuildContext context, SignUpState state) {
                  if (state.loading) {
                    return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                        ));
                  } else if (state.error != null && state.error['message'].isNotEmpty) {
                    return AlertDialog(
                      title: Text("Signup Failure"),
                      content: Text(state.error['message']),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => navigateToSignUp()),
                      ],
                    );
                  } else {
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsetsDirectional.only(start:40.0,end:40.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              autofocus: false,
                              validator: (String value) {
                                bool validName = value.isNotEmpty && value.trim().isNotEmpty && value.length > 2;
                                return (validName)
                                    ? null
                                    : "Please enter valid name (must be longer than 2 characters)";
                              },
                              onSaved: (String value) {
                                _name = value;
                              },
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.email), hintText: "Name"),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              autofocus: false,
                              validator: (String value) {
                                bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
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
                                validator: (val) =>
                                val.length < 6 ? 'Password too short.' : null,
                                onSaved: (String value) {
                                  _password = value;
                                },
                                obscureText: _obscureText,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.lock), hintText: "Password"),
                              ),
                                new Positioned(
                                  left: (MediaQuery.of(context).size.width-150.0),
                                  child: new TextButton(
                                      onPressed: _toggle,
                                      child: new Text(_obscureText ? "Show" : "Hide"))
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Center(
                              child: ButtonTheme(
                                minWidth: 256.0,
                                height: 32.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white10, // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      BlocProvider.of<SignUpBloc>(context)
                                          .onSignUpWithEmail(_name, _email, _password);
                                    }
                                  },
                                  child: Text("Sign up",
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            })));
  }

  void navigateToLogin() {
    NavigationHelper.navigateToLogInWithEmail(context);
  }
  void navigateToSignUp() {
    NavigationHelper.navigateToSignUp(context);
  }
}
