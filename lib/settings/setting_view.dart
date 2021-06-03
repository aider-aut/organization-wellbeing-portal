import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/model/login/login_repo.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        key: _scaffoldKey,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 125),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: IconButton(
                              icon: Icon(Icons.lock_open),
                              onPressed: () {
                                LoginRepo.getInstance()
                                    .signOut()
                                    .then((success) {
                                  if (success) {
                                    navigateToLogin();
                                  }
                                });
                              },
                            )))
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: BlocWidget<SettingEvent, SettingState, SettingBloc>(
                builder: (BuildContext context, SettingState state) {
              Widget content;
              if (state.loading) {
                content = Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    )));
              } else if (state.error != null &&
                  state.error['message'].isNotEmpty) {
                content = AlertDialog(
                  title: Text("Something went wrong"),
                  content: Text(state.error['message']),
                  actions: [
                    TextButton(
                        child: Text("OK"), onPressed: () => navigateToLogin()),
                  ],
                );
              } else {
                content = Container(
                    padding: EdgeInsets.only(top: 0, left: 20, right: 0),
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Container(
                          height: 50,
                          child: InkWell(
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Image.asset(
                                          'assets/icons/account.png')),
                                  Expanded(
                                    flex: 4,
                                    child: Text("Account",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Image.asset(
                                          'assets/icons/chevron-right.png')),
                                ],
                              ),
                              onTap: () => navigateToAccount()),
                        ),
                        Container(
                          height: 50,
                          child: InkWell(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child:
                                        Image.asset('assets/icons/info.png')),
                                Expanded(
                                    flex: 4,
                                    child: Text("About AWA",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: Image.asset(
                                        'assets/icons/chevron-right.png')),
                              ],
                            ),
                            onTap: () => navigateToAbout(),
                          ),
                        ),
                      ],
                    ));
              }
              return content;
            })));
  }

  void navigateToLogin() {
    NavigationHelper.navigateToLogInWithEmail(_scaffoldKey.currentContext,
        addToBackStack: false);
  }

  void navigateToAccount() {
    NavigationHelper.navigateToAccount(_scaffoldKey.currentContext);
  }

  void navigateToAbout() {
    NavigationHelper.navigateToAbout(_scaffoldKey.currentContext);
  }

  void navigateToSignUp() {
    NavigationHelper.navigateToSignUp(_scaffoldKey.currentContext);
  }
}
