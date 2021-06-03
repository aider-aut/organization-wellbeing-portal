import 'package:chatapp/model/user/user_repo.dart';
import 'package:flutter/material.dart';

class WellbeingScreen extends StatefulWidget {
  WellbeingScreen({
    Key key,
    @required this.challenges,
    @required this.imgUrls,
  }) : super(key: key);
  final Map<String, String> imgUrls;
  final List<String> challenges;

  @override
  State<StatefulWidget> createState() => _WellbeingState(imgUrls, challenges);
}

class _WellbeingState extends State<WellbeingScreen> {
  final Map<String, String> imgUrls;
  _WellbeingState(this.imgUrls, this._challenges);
  String emotion;
  String displayName;
  List<String> _challenges = [];
  String happyUrl, sadUrl, confusedUrl, angryUrl;

  @override
  void initState() {
    super.initState();
    emotion = UserRepo().getEmotion();
    displayName = UserRepo().getUserName();
    happyUrl =
        'assets/icons/emotions/${emotion == "Happy" ? "happy-active.png" : "happy.png"}';
    sadUrl =
        'assets/icons/emotions/${emotion == "Sad" ? "sad-active.png" : "sad.png"}';
    confusedUrl =
        'assets/icons/emotions/${emotion == "Confused" ? "confused-active.png" : "confused.png"}';
    angryUrl =
        'assets/icons/emotions/${emotion == "Angry" ? "angry-active.png" : "angry.png"}';
  }

  @override
  Widget build(BuildContext context) {
    void updateEmotions(String value) {
      setState(() {
        UserRepo().setEmotion(value);
        happyUrl =
            'assets/icons/emotions/${value == "Happy" ? "happy-active.png" : "happy.png"}';
        sadUrl =
            'assets/icons/emotions/${value == "Sad" ? "sad-active.png" : "sad.png"}';
        confusedUrl =
            'assets/icons/emotions/${value == "Confused" ? "confused-active.png" : "confused.png"}';
        angryUrl =
            'assets/icons/emotions/${value == "Angry" ? "angry-active.png" : "angry.png"}';
      });
    }

    return Container(
        height: MediaQuery.of(context).size.height - 305,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  child: new Image.network(widget.imgUrls['mood']),
                ),
                Text("My Mood")
              ],
            ),
            FractionallySizedBox(
                widthFactor: 0.95,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(4, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: InkWell(
                              child: Image.asset(happyUrl),
                              onTap: () => {updateEmotions("Happy")}),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: InkWell(
                              child: Image.asset(confusedUrl),
                              onTap: () => {updateEmotions("Confused")}),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: InkWell(
                              child: Image.asset(sadUrl),
                              onTap: () => {updateEmotions("Sad")}),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: InkWell(
                              child: Image.asset(angryUrl),
                              onTap: () => {updateEmotions("Angry")}),
                        ),
                      )
                    ],
                  ),
                )),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(15),
                  child: new Image.network(widget.imgUrls['barrier']),
                ),
                Text("My Challenges")
              ],
            ),
            FractionallySizedBox(
              widthFactor: .95,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(4, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _challenges.length == 0
                      ? [
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(left: 50),
                                  child: Text(
                                      "Please checkout our chatbot to take an assessment."))),
                        ]
                      : _challenges.map((challenge) {
                          if (_challenges.indexOf(challenge) == 0) {
                            return Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(challenge),
                              ),
                            );
                          }
                          return Expanded(
                            child: Container(
                              child: Text(challenge),
                            ),
                          );
                        }).toList(),
                ),
              ),
            )
          ],
        )));
  }
}
