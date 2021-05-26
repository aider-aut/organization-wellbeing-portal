import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/settings/setting_bloc.dart';
import 'package:chatapp/settings/setting_event.dart';
import 'package:chatapp/settings/setting_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutState();
}

class _AboutState extends State<AboutScreen> {
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
                        'About AWA',
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
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    height: MediaQuery.of(context).size.height,
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    children: [
                                      Text(
                                        'AWA was designed with New Zealand’s Small Businesses in mind. We aim to deliver a simple yet effective tool of navigating the stress and monotony of daily life.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Small Business Owners and Employees do not get to experience the same facilities a bigger company does. AWA is here to bridge that gap.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'We also aim to encourage conversations regarding mental health and wellbeing in the work culture. It is important to keep in mind that our managers, employees and co-workers get stressed out just the same way we do, and just checking in can make all the difference!',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "To learn more about AWA, visit",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      RichText(
                                          text: TextSpan(
                                        text: " https://www.aider.ai",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async => {
                                                await canLaunch(
                                                        'https://www.aider.ai')
                                                    ? await launch(
                                                        'https://www.aider.ai')
                                                    : throw 'Could not launch https://www.aider.ai'
                                              },
                                      )),
                                      Image.asset(
                                        'assets/about.png',
                                        width: 200,
                                        height: 200,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
