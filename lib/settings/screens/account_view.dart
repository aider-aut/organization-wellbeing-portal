import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/settings/setting_bloc.dart';
import 'package:chatapp/settings/setting_event.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<AccountScreen> {
  String _userName, _birthday, _email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              child: Icon(Icons.chevron_left),
                            ),
                            Text("Settings",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black))
                          ],
                        ),
                        onTap: () => navigateToSettings(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'My Account',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            body: BlocWidget<SettingEvent, SettingState, SettingBloc>(
                builder: (BuildContext context, SettingState state) {
              _userName = BlocProvider.of<SettingBloc>(context).getUserName();
              _birthday =
                  BlocProvider.of<SettingBloc>(context).getUserBirthday();
              _email = BlocProvider.of<SettingBloc>(context).getUserEmail();
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
                        child: Text("OK"),
                        onPressed: () => navigateToSettings()),
                  ],
                );
              } else {
                content = Container(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text("Username",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                  child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.5,
                                      child: Text(_userName,
                                          style: TextStyle(
                                            fontSize: 14,
                                          )),
                                    ),
                                    Container(
                                        width: 30,
                                        child: Image.asset(
                                            'assets/icons/chevron-right.png')),
                                  ],
                                ),
                                onTap: () => navigateToEdit('username'),
                              )),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('Birthday',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                  child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.5,
                                      child: Text(_birthday,
                                          style: TextStyle(fontSize: 14)),
                                    ),
                                    Container(
                                        width: 30,
                                        child: Image.asset(
                                            'assets/icons/chevron-right.png')),
                                  ],
                                ),
                                onTap: () => navigateToEdit('birthday'),
                              )),
                            ],
                          ),
                        ),
                        Container(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text("Email",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                    flex: 2,
                                    child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Opacity(
                                                opacity: 0.5,
                                                child: Text(_email,
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                            Container(
                                                width: 30,
                                                child: Image.asset(
                                                    'assets/icons/chevron-right.png')),
                                          ],
                                        ),
                                        onTap: () => navigateToEdit('email'))),
                              ],
                            )),
                      ],
                    ));
              }
              return content;
            })));
  }

  void navigateToSettings() {
    NavigationHelper.navigateToSettings(context);
  }

  void navigateToEdit(String info) {
    NavigationHelper.navigateToEdit(context, info);
  }
}
