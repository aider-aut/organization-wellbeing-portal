import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:chatapp/main/profile_view.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/settings/setting_view.dart';
import 'package:chatapp/welcome/welcome_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/chat/chatroom.dart';
import '../navigation_helper.dart';
import '../util/constants.dart';
import 'main_bloc.dart';
import 'main_state.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // UserRepo.getInstance().isFirstUser().then((value) {
    //   setState(() {
    //     _isFirstUser = value;
    //   });
    // });
    // UserRepo.getInstance().isEmailVerified().then((value) {
    //   setState(() {
    //     _isEmailVerified = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    // if (_isFirstUser && !_isEmailVerified) {
    //   return WelcomeStepScreen();
    // }
    return Scaffold(
      body: BlocWidget<MainEvent, MainState, MainBloc>(
        builder: (BuildContext context, MainState state) => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.lock_open),
                onPressed: () {
                  BlocProvider.of<MainBloc>(context).logout(navigateToLogin);
                },
              )
            ],
          ),
          body: Builder(
            builder: (BuildContext context) {
              Widget content;
              if (state.isLoading) {
                content = Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).backgroundColor),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4.0,
                      ),
                    ));
              } else if (_selectedIndex == 0) {
                content = ProfileScreen(
                    displayName: state.name,
                    profileImage: state.profileImg,
                    imageUrls: state.imageUrls);
              } else if (_selectedIndex == 3) {
                content = SettingScreen();
              } else {
                content = Center(child: Text("something went wrong.."));
              }
              return _wrapContentWithFab(context, content);
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.black,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: SizedBox(
                      child: Image.asset(
                        'assets/icons/home.png',
                      ),
                      height: 30),
                  label: _selectedIndex == 0 ? 'Home' : ''),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      child: InkWell(
                          onTap: () => BlocProvider.of<MainBloc>(context)
                              .retrieveChatroomForChatBotConversation(
                                  navigateToChatroom),
                          child: Image.asset('assets/icons/chatbot.png')),
                      height: 30),
                  label: _selectedIndex == 1 ? 'AWA' : ''),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      child: Image.asset(
                        'assets/icons/idea.png',
                      ),
                      height: 30),
                  label: _selectedIndex == 2 ? 'Insights' : ''),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      child: Image.asset(
                        'assets/icons/settings.png',
                      ),
                      height: 30),
                  label: _selectedIndex == 3 ? 'Settings' : ''),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _wrapContentWithFab(BuildContext context, Widget content) {
    return Stack(
      children: <Widget>[
        content,
        Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(UIConstants.NORMAL_PADDING),
          child: FloatingActionButton(
              onPressed: _clickAddChat,
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.blueAccent,
              elevation: UIConstants.NORMAL_ELEVATION),
        )
      ],
    );
  }

  void _clickAddChat() {
    NavigationHelper.navigateToAddChat(context, addToBackStack: true);
  }

  void navigateToLogin() {
    NavigationHelper.navigateToLogin(context);
  }

  void navigateToChatroom(SelectedChatroom chatroom) {
    NavigationHelper.navigateToInstantMessaging(
      context,
      chatroom.name,
      chatroom.id,
      addToBackStack: true,
    );
  }
}
