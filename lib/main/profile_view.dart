import 'package:chatapp/main/main_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    Key key,
    @required this.displayName,
    @required this.profileImage,
    @required this.imageUrls,
  }) : super(key: key);
  final String displayName;
  final Map<String, String> imageUrls;
  final String profileImage;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {

  String currentEmotion;
  var _options = [true, false, false];

  @override
  Widget build(BuildContext context) {
    String emotion = BlocProvider.of<MainBloc>(context).getEmotion();
    String happyUrl = 'assets/icons/emotions/${emotion == "Happy" ? "happy-active.png" : "happy.png"}';
    String sadUrl = 'assets/icons/emotions/${emotion == "Sad" ? "sad-active.png" : "sad.png"}';
    String confusedUrl = 'assets/icons/emotions/${emotion == "Confused" ? "confused-active.png" : "confused.png"}';
    String angryUrl = 'assets/icons/emotions/${emotion == "Angry" ? "angry-active.png" : "angry.png"}';

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.imageUrls['background']),
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
            child: Image.network(
              widget.profileImage != null
                  ? widget.profileImage
                  : widget.imageUrls['profile'],
              height: 70,
              width: 70,
            ),
            radius: 50,
            backgroundColor: Colors.grey,
          ),
          Center(
            child: Text(widget.displayName),
          ),
          SizedBox(height: 50),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 20,
                    child: Center(
                      child:InkWell(
                        child: Text(
                          "My History",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () => setState(() {
                          _options = [true, false, false];
                        })
                      )
                    )
                ),
              ),
              Expanded(
                child: Container(
                    height: 20,
                    child: Center(
                        child: InkWell(
                          child: Text(
                            "My Employees",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () => setState((){
                            _options = [false, true, false];
                          })
                        )
                    )
                ),
              ),
              Expanded(
                  child: Container(
                      height: 20,
                    child:Center(
                      child: InkWell(
                        child: Text(
                          "Notifications",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap:() => setState((){
                          _options = [false, false, true];
                        })
                      )
                    )
                  )
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
                Expanded(
                  child: Center(
                    child: InkWell(
                      child:
                      Container(
                        width:100,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: _options[0] ? Colors.white : Colors.transparent
                        ),
                    ),
                      onTap: () => setState((){
                        _options = [true, false, false];
                      })
                    ),
                  )
                ),
              Expanded(
                  child: Center(
                    child: InkWell(
                        child:
                        Container(
                          width:100,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: _options[1] ? Colors.white : Colors.transparent
                          ),
                        ),
                        onTap: () => setState((){
                          _options = [false, true, false];
                        })
                    ),
                  )
              ),
              Expanded(
                  child: Center(
                    child: InkWell(
                        child:
                        Container(
                          width:100,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: _options[2] ? Colors.white : Colors.transparent
                          ),
                        ),
                        onTap: () => setState((){
                          _options = [false, false, true];
                        })
                    ),
                  )
              ),
            ]
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(15),
                child: new Image.network(widget.imageUrls['mood']),
              ),
              Text("My Mood")
            ],
          ),
          FractionallySizedBox(
            widthFactor: 0.95,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(4,5), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: InkWell(
                          child: Image.asset(happyUrl),
                          onTap: () => {
                          setState(() {
                            happyUrl = 'assets/icons/emotions/happy-active.png';
                            sadUrl = 'assets/icons/emotions/sad.png';
                            confusedUrl = 'assets/icons/emotions/confused.png';
                            angryUrl ='assets/icons/emotions/angry.png';
                            BlocProvider.of<MainBloc>(context).updateEmotion("Happy");
                          })
                      }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                          child: Image.asset(confusedUrl),
                          onTap: () => setState(() {
                            happyUrl = 'assets/icons/emotions/happy.png';
                            sadUrl = 'assets/icons/emotions/sad.png';
                            confusedUrl = 'assets/icons/emotions/confused-active.png';
                            angryUrl ='assets/icons/emotions/angry.png';
                            BlocProvider.of<MainBloc>(context).updateEmotion("Confused");
                          })),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                          child: Image.asset(sadUrl),
                          onTap: () => setState(() {
                            happyUrl = 'assets/icons/emotions/happy.png';
                            sadUrl = 'assets/icons/emotions/sad-active.png';
                            confusedUrl = 'assets/icons/emotions/confused.png';
                            angryUrl ='assets/icons/emotions/angry.png';
                            BlocProvider.of<MainBloc>(context).updateEmotion("Sad");
                          })),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                          child: Image.asset(angryUrl),
                          onTap: () => setState(() {
                            happyUrl = 'assets/icons/emotions/happy.png';
                            sadUrl = 'assets/icons/emotions/sad.png';
                            confusedUrl = 'assets/icons/emotions/confused.png';
                            angryUrl ='assets/icons/emotions/angry-active.png';
                            BlocProvider.of<MainBloc>(context).updateEmotion("Angry");
                          })),
                    ),
                  )
                ],
              ),
            )
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(15),
                child: new Image.network(widget.imageUrls['barrier']),
              ),
              Text("My Challenges")
            ],
          ),
          FractionallySizedBox(
            widthFactor: .95,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(4,5), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left:10),
                      child: Text("· Depression"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text("· Drug use"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
