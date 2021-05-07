import 'package:chatapp/main/welcome_view.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/main/main_event.dart';

import 'main_bloc.dart';
import 'main_state.dart';
import 'main_user_item.dart';
import '../util/constants.dart';
import '../navigation_helper.dart';
import '../model/chat/chatroom.dart';
import 'package:chatapp/main/pages/profile_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  int _selectedIndex = 0;
  Image _profileIcon = new Image.asset(
    'assets/icons/user.png',
  );
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    if (LoginRepo.getInstance().isNewUser()) {
      return WelcomeScreen();
    }
    return BlocWidget<MainEvent, MainState, MainBloc>(
      builder: (BuildContext context, MainState state) => Scaffold(
        appBar: AppBar(
          title: Text('ChatApp'),
          backgroundColor: Colors.lightGreen,
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
              content = Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ),
              );
            } else if (state.chatrooms.isEmpty) {
              content = Center(
                // child: Text(
                //   "Looks like you don't have any active chatrooms\nLet's start one right now!",
                //   textAlign: TextAlign.center,
                // ),
                child: Profile(),
              );
            } else {
              content = Center(child: Text("HELLO"));
            }
            return _wrapContentWithFab(context, content);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SizedBox(
                    child: Image.asset(
                      'assets/icons/user.png',
                    ),
                    height: 40),
                activeIcon: SizedBox(
                    child: Image.asset(
                      'assets/icons/selected-user.png',
                    ),
                    height: 40),
                label: _selectedIndex == 0 ? 'Profile' : ''),
            BottomNavigationBarItem(
                icon: SizedBox(
                    child: InkWell(
                        onTap: () => BlocProvider.of<MainBloc>(context)
                            .retrieveChatroomForChatBotConversation(
                                navigateToChatroom),
                        child: Image.asset('assets/icons/chatbot.png')),
                    height: 40),
                activeIcon: SizedBox(
                    child: Image.asset('assets/icons/selected-chatbot.png'),
                    height: 40),
                label: _selectedIndex == 1 ? 'Chatbot' : '',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: SizedBox(
                    child: Image.asset(
                      'assets/icons/settings.png',
                    ),
                    height: 40),
                activeIcon: SizedBox(
                    child: Image.asset(
                      'assets/icons/selected-settings.png',
                    ),
                    height: 40),
                label: _selectedIndex == 2 ? 'Settings' : '',
                backgroundColor: Colors.purple),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
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

  UserItem _buildItem(Chatroom chatroom) {
    return UserItem(user: chatroom.participants.first);
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
