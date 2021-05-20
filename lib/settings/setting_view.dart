import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/settings/setting_bloc.dart';
import 'package:chatapp/settings/setting_event.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: BlocWidget<SettingEvent, SettingState, SettingBloc>(
                builder: (BuildContext context, SettingState state) {
                  if (state.loading) {
                    return Container(
                        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                          ))
                    );
                  } else if (state.error != null &&
                      state.error['message'].isNotEmpty) {
                    return AlertDialog(
                      title: Text("Signup Failure"),
                      content: Text(state.error['message']),
                      actions: [
                        TextButton(
                            child: Text("OK"), onPressed: () => navigateToLogin()),
                      ],
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 0),
                      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
                      child: Column(
                            children: [
                              Center(
                          child: Text("Settings",
                          style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ))),
                              SizedBox(height: 50),
                              Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Image.asset('assets/icons/account.png')
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text("Account", style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      )),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Image.asset('assets/icons/chevron-right.png')
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset('assets/icons/edit.png')
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("Manage tasks", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    )),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset('assets/icons/chevron-right.png')
                                  ),
                                ],
                              ),
                        ),
                        Container(
                          height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset('assets/icons/privacy.png'),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("Privacy and safety", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ))
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset('assets/icons/chevron-right.png')
                                  ),
                                ],
                              ),
                        ),
                        Container(
                            height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset('assets/icons/notifications.png')
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("Notifications", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ))
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset('assets/icons/chevron-right.png')
                                  ),
                                ],
                              )),
                        Container(
                            height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset('assets/icons/icloud.png')
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("iCloud sync", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ))
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset('assets/icons/chevron-right.png')
                                  ),
                                ],
                              )),
                        Container(
                          height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset('assets/icons/info.png')
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("About AWA", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ))
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Image.asset('assets/icons/chevron-right.png')
                                  ),
                                ],
                              ),
                        ),
                            ],
                          )
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
