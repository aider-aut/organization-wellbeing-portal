import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase;

class Profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<Profile> {
  List<bool> _selecteds = [true, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/three_colours_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Container(
              child: null,
              height: 20,
            ),
            CircleAvatar(
              child: new Image.asset(
                "assets/icons/unnamed.png",
                height: 70,
                width: 70,
              ),
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            Center(
              child: Text("user name"),
            ),
            Center(
              child: Text(firebase.FirebaseAuth.instance.currentUser.email),
            ),
            ToggleButtons(
              isSelected: _selecteds,
              borderColor: Colors.transparent,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "My History",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "My Employees",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Notifications",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onPressed: (index) {
                setState(() {
                  _selecteds[index] = !_selecteds[index];
                });
              },
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  child: new Image.asset(
                    "assets/icons/Group.png",
                    height: 30,
                  ),
                ),
                Text("My Mood")
              ],
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: new Image.asset("assets/icons/happy2.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: new Image.asset("assets/icons/confused2.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: new Image.asset("assets/icons/sad3.png"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: new Image.asset("assets/icons/angry3.png"),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  child: new Image.asset(
                    "assets/icons/barrier1.png",
                    height: 30,
                  ),
                ),
                Text("My Challenges")
              ],
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text("· Depression"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text("· Drug use"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
