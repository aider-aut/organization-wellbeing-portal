import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';

import 'main_bloc.dart';
import 'main_state.dart';
import 'main_user_item.dart';
import '../util/constants.dart';
import '../navigation_helper.dart';
import '../model/chat/chatroom.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocWidget<MainEvent, MainState, MainBloc>(
      builder: (BuildContext context, MainState state) => Scaffold(
        appBar: AppBar(
          title: Text('ChatApp'),
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
                child: Text(
                  "Looks like you don't have any active chatrooms\nLet's start one right now!",
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              content = ListView.builder(
                padding: EdgeInsets.all(UIConstants.SMALL_PADDING),
                itemBuilder: (context, index) {
                  return InkWell(
                    child: _buildItem(state.chatrooms[index]),
                    onTap: () {
                      BlocProvider.of<MainBloc>(context)
                          .retrieveChatroomForParticipant(
                        state.chatrooms[index].participants.first,
                        navigateToChatroom,
                      );
                    },
                  );
                },
                itemCount: state.chatrooms.length,
              );
            }
            return _wrapContentWithFab(context, content);
          },
        ),
        bottomNavigationBar: GradientBottomNavigationBar(
          backgroundColorStart: Colors.purple,
          backgroundColorEnd: Colors.deepOrange,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: _selectedIndex != 0
                    ? new Image.asset(
                        'assets/icons/user.png',
                      )
                    : new Image.asset(
                        'assets/icons/selected-user.png',
                      ),
                title: Text("")),
            BottomNavigationBarItem(
                icon: _selectedIndex != 1
                    ? new Image.asset(
                        'assets/icons/chatbot.png',
                      )
                    : new Image.asset(
                        'assets/icons/selected-chatbot.png',
                      ),
                title: Text("")),
            BottomNavigationBarItem(
                icon: _selectedIndex != 2
                    ? new Image.asset(
                        'assets/icons/settings.png',
                      )
                    : new Image.asset(
                        'assets/icons/selected-settings.png',
                      ),
                title: Text("")),
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
