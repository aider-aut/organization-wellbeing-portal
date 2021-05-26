import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/create_chatroom/create_chatroom_bloc.dart';
import 'package:chatapp/create_chatroom/create_chatroom_event.dart';
import 'package:chatapp/create_chatroom/create_chatroom_state.dart';
import 'package:chatapp/main/main_user_item.dart';
import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChatroomScreen extends StatefulWidget {
  CreateChatroomScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateChatroomState();
}

class _CreateChatroomState extends State<CreateChatroomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select user"),
      ),
      body: BlocWidget<CreateChatroomEvent, CreateChatroomState,
          CreateChatroomBloc>(
        builder: (context, CreateChatroomState state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                child: _buildItem(state.users[index]),
                onTap: () {
                  BlocProvider.of<CreateChatroomBloc>(context).startChat(
                    state.users[index],
                    navigateToSelectedChatroom,
                  );
                },
              );
            },
            itemCount: state.users.length,
            padding: EdgeInsets.all(UIConstants.SMALL_PADDING),
          );
        },
      ),
    );
  }

  Widget _buildItem(User user) {
    return UserItem(user: user);
  }

  void navigateToSelectedChatroom(SelectedChatroom chatroom) {
    NavigationHelper.navigateToInstantMessaging(
        context, chatroom.name, chatroom.id);
  }
}
