import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/instant_messaging/instant_messaging_view.dart';
import 'package:chatapp/main/main_bloc.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:chatapp/main/main_state.dart';
import 'package:chatapp/main/profile_view.dart';
import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/settings/screens/about_screen.dart';
import 'package:chatapp/settings/screens/account_view.dart';
import 'package:chatapp/settings/screens/edit_account.dart';
import 'package:chatapp/settings/setting_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndexScreen extends StatefulWidget {
  IndexScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IndexState();
}

class _IndexState extends State<IndexScreen> {
  GlobalKey<NavigatorState> _navigatorKey;
  SelectedChatroom _chatroom;
  @override
  void initState() {
    super.initState();
    _navigatorKey = new GlobalKey<NavigatorState>();
  }

  int _currentIndex = 0;
  String _currentPage = 'Home';
  Map<int, String> _currentLocation = {0: 'Home', 1: 'AWA', 2: 'Settings'};
  @override
  Widget build(BuildContext context) {
    return BlocWidget<MainEvent, MainState, MainBloc>(
        builder: (BuildContext context, MainState state) {
      Widget content;
      _chatroom = BlocProvider.of<MainBloc>(context).getChatroom();
      content = Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            if (_navigatorKey.currentState.canPop()) {
              _navigatorKey.currentState.pop();
              return false;
            }
            return true;
          },
          child: Navigator(
              key: _navigatorKey,
              initialRoute: 'Home',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                if (settings.name == 'Home') {
                  builder = (BuildContext context) => ProfileScreen();
                } else if (settings.name == 'AWA') {
                  builder = (BuildContext context) => InstantMessagingScreen(
                        chatroomId: _chatroom.id,
                        displayName: _chatroom.name,
                      );
                } else if (settings.name == 'Settings') {
                  builder = (BuildContext context) => SettingScreen();
                } else if (settings.name == 'Account') {
                  builder = (BuildContext context) => AccountScreen();
                } else if (settings.name == 'AccountEdit') {
                  final args = settings.arguments;
                  builder =
                      (BuildContext context) => EditAccountScreen(info: args);
                } else if (settings.name == 'About') {
                  builder = (BuildContext context) => AboutScreen();
                }

                return MaterialPageRoute(builder: builder, settings: settings);
              }),
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
                label: _currentPage == 'Home' ? 'Home' : ''),
            BottomNavigationBarItem(
                icon: SizedBox(
                    child: Image.asset('assets/icons/chatbot.png'), height: 30),
                label: _currentPage == 'AWA' ? 'AWA' : ''),
            BottomNavigationBarItem(
                icon: SizedBox(
                    child: Image.asset(
                      'assets/icons/settings.png',
                    ),
                    height: 30),
                label: _currentPage == 'Settings' ? 'Settings' : ''),
          ],
          currentIndex: _currentIndex,
          onTap: (index) => {
            setState(() {
              setState(() {
                _currentIndex = index;
                _currentPage = _currentLocation[index];
              });
              print("HERE: ${_currentLocation[index]}");
              _navigatorKey.currentState.pushNamed(_currentLocation[index]);
            })
          },
        ),
      );
      return content;
    });
  }
}
