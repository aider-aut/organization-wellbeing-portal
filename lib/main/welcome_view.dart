import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/login/login_bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/main/main_view.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<WelcomeScreen> {
  bool _isEmailVerified = false;
  bool _isFirstUser = false;

  @override
  void initState() {
    super.initState();
    UserRepo.getInstance().isEmailVerified().then((value) {
      setState(() {
        _isEmailVerified = value;
      });
    });
    UserRepo.getInstance().isFirstUser().then((value) {
      setState(() {
        _isFirstUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void navigateToLogin() {
      NavigationHelper.navigateToLogin(context, addToBackStack: false);
    }

    UserRepo.getInstance().isEmailVerified().then((value) {
      setState(() {
        _isEmailVerified = value;
      });
    });

    if (!_isFirstUser && _isEmailVerified) {
      return MainScreen();
    }

    return BlocWidget<LoginEvent, LoginState, LoginBloc>(
        builder: (BuildContext context, LoginState state) =>
            Scaffold(body: Builder(builder: (BuildContext context) {
              Widget content;
              if (state.loading) {
                content = Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                );
              } else if (!_isEmailVerified) {
                content = AlertDialog(
                  title: Text("Verify Email"),
                  content: Text("Please Verify your email before continuing"),
                  actions: [
                    TextButton(
                        child: Text("OK"), onPressed: () => navigateToLogin()),
                  ],
                );
              } else {
                content = Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Image.asset("assets/icons/aider-logo.png",
                        fit: BoxFit.fitWidth),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.keyboard_control,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: 300,
                        child: Text(
                          "Hi, I'm Aider, your very own digital business assistant.",
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.signal_cellular_alt_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "With a single tap, I can give you information relevant to your business.",
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Also, I can update you with specific news or metrics, that you schedule.",
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Talking to me is as easy as \"Hello\".",
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                        child: Text("Next"),
                        onPressed: () {
                          navigateToDemographics();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // background
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)))),
                  )
                ]);
              }
              return content;
            })));
  }

  void navigateToDemographics() {
    NavigationHelper.navigateToDemographics(context);
  }
}
