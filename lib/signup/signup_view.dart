import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/signup/signup_bloc.dart';
import 'package:chatapp/signup/signup_event.dart';
import 'package:chatapp/signup/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final _formKey = new GlobalKey<FormState>();
  String _email, _password, _name;
  bool _obscureText = true;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

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
                color: Colors.black,
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: BlocWidget<SignUpEvent, SignUpState, SignUpBloc>(
                builder: (BuildContext context, SignUpState state) {
              if (state.loading) {
                return Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    )));
              } else if (state.error != null &&
                  state.error['message'].isNotEmpty) {
                return AlertDialog(
                  title: Text("Signup Failure"),
                  content: Text(state.error['message']),
                  actions: [
                    TextButton(
                        child: Text("OK"), onPressed: () => navigateToSignUp()),
                  ],
                );
              } else {
                return SingleChildScrollView(
                    child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).backgroundColor),
                  child: Column(children: [
                    SizedBox(height: 60),
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
                                        child: Text("User name",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF3E4347),
                                            ),
                                            textAlign: TextAlign.center),
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        validator: (String value) {
                                          bool validName = value.isNotEmpty &&
                                              value.trim().isNotEmpty &&
                                              value.length > 2;
                                          return (validName)
                                              ? null
                                              : "Please enter valid name (must be longer than 2 characters)";
                                        },
                                        onSaved: (String value) {
                                          _name = value;
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
                                  child: Stack(children: [
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
                                    )
                                  ])),
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
                                            ? 'Password too short.'
                                            : null,
                                        onChanged: (String value) {
                                          _password = value;
                                        },
                                        obscureText: _obscureText,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      new Positioned(
                                          left: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150.0),
                                          child: new TextButton(
                                              onPressed: _toggle,
                                              child: new Text(_obscureText
                                                  ? "Show"
                                                  : "Hide"))),
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
                                        child: Text("Confirm Password",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF3E4347),
                                            ),
                                            textAlign: TextAlign.center),
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        validator: (val) => val != _password
                                            ? 'Password does not match'
                                            : null,
                                        obscureText: _obscureText,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      Positioned(
                                          left: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150.0),
                                          child: TextButton(
                                              onPressed: _toggle,
                                              child: new Text(_obscureText
                                                  ? "Show"
                                                  : "Hide")))
                                    ],
                                  )),
                              SizedBox(height: 15.0),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () => showMaterialDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            selectedDate: _selectedDate,
                                            onChanged: (value) => setState(
                                                () => _selectedDate = value),
                                          ),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFF4F9FE)),
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Date",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF3E4347),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Text(
                                                  _selectedDate.day.toString()),
                                            ],
                                          ))),
                                  SizedBox(width: 15),
                                  InkWell(
                                      onTap: () => showMaterialDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            selectedDate: _selectedDate,
                                            onChanged: (value) => setState(
                                                () => _selectedDate = value),
                                          ),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10),
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFF4F9FE)),
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Month",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF3E4347),
                                                    ),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Text(_selectedDate.month
                                                  .toString()),
                                            ],
                                          ))),
                                  SizedBox(width: 15),
                                  InkWell(
                                      onTap: () => showMaterialDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now(),
                                            selectedDate: _selectedDate,
                                            onChanged: (value) => setState(
                                                () => _selectedDate = value),
                                          ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 50,
                                        padding:
                                            EdgeInsets.only(left: 10, top: 10),
                                        decoration: new BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xFFF4F9FE)),
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text("Year",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF3E4347),
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ),
                                            Text(_selectedDate.year.toString()),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
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
                                        BlocProvider.of<SignUpBloc>(context)
                                            .onSignUpWithEmail(
                                                _name,
                                                _selectedDate,
                                                _email,
                                                _password);
                                      }
                                    },
                                    child: Text("Sign up",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        // background
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                              )),
                              SizedBox(height: 30),
                            ]),
                      ),
                    ),
                  ]),
                ));
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
