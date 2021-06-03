import 'package:chatapp/navigation_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      Widget content;
      content = Container(
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          child: AlertDialog(
            title: Text("Verify Email"),
            content: Text("Please Verify your email before continuing"),
            actions: [
              TextButton(
                  child: Text("OK"), onPressed: () => navigateToLogin(context)),
            ],
          ));
      return content;
    }));
  }

  void navigateToLogin(BuildContext context) {
    NavigationHelper.navigateToLogin(context);
  }
}
