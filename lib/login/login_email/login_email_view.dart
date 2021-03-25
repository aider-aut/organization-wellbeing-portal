import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
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
              if (state.loading) {
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ));
              } else {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 215.0),
                          TextFormField(
                            autofocus: false,
                            validator: (String value) {
                              return (value != null && value.contains('@'))
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
                          new FlatButton(
                              onPressed: _toggle,
                              child: new Text(_obscureText ? "Show" : "Hide")),
                          SizedBox(height: 15.0),
                          ButtonTheme(
                            minWidth: 256.0,
                            height: 32.0,
                            child: RaisedButton(
                                onPressed: () {
                                  final form = _formKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    BlocProvider.of<LoginBloc>(context)
                                        .onLoginWithEmail(_email, _password);
                                  }
                                },
                                child: Text("Sign in",
                                    style: TextStyle(color: Colors.black)),
                                color: Colors.white10),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            })));
  }
}
