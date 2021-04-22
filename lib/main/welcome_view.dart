import 'package:chatapp/main/main_view.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Welcome to Aider',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[600],
                  backgroundColor: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Container(
                width: 250,
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
                      "Hi, I'm Aider, your very own digital business assitant.",
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
                    width: 300,
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
                    width: 300,
                    child: Text(
                      "Also, I can update you with specifc news or metrics, that you schedule.",
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
                    width: 300,
                    child: Text(
                      "Taking to me is as easy as \"Hello\".",
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
                  child: RaisedButton(
                      child: Text("Next"),
                      onPressed: () {
                        LoginRepo.getInstance().setIsNewUser(false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))))
            ],
          ),
        );
  }
}
