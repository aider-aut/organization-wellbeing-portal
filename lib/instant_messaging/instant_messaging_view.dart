import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:chatapp/base/bloc_widget.dart';
import 'package:chatapp/instant_messaging/instant_messaging_bloc.dart';
import 'package:chatapp/instant_messaging/instant_messaging_event.dart';
import 'package:chatapp/instant_messaging/instant_messaging_state.dart';
import 'package:chatapp/model/chat/chat_repo.dart';
import 'package:chatapp/model/message/message.dart';
import 'package:chatapp/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InstantMessagingScreen extends StatefulWidget {
  InstantMessagingScreen(
      {Key key, @required this.displayName, @required this.chatroomId})
      : super(key: key);

  final String displayName;
  final String chatroomId;
  final TextEditingController _textEditingController =
      IMTextEditingController();

  @override
  State<StatefulWidget> createState() => _InstantMessagingState(chatroomId);
}

class _InstantMessagingState extends State<InstantMessagingScreen> {
  final String chatroomId;

  _InstantMessagingState(this.chatroomId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocWidget<InstantMessagingEvent, InstantMessagingState,
          InstantMessagingBloc>(
        builder: (context, InstantMessagingState state) {
          if (state.error) {
            return Center(
              child: Text("An error ocurred"),
            );
          } else if (state.isLoading) {
            return Container(
              color: Colors.grey[400],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: UIConstants.NORMAL_PADDING),
                        padding: EdgeInsets.symmetric(
                            vertical: UIConstants.SMALL_PADDING,
                            horizontal: UIConstants.SMALL_PADDING),
                        child: TextField(
                          maxLines: null,
                          controller: widget._textEditingController,
                          focusNode: FocusNode(),
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.blueAccent,
                          decoration:
                              InputDecoration(hintText: "Your message..."),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            _openPictureDialog(context);
                          }),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    ),
                    Container(
                      child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _send(context, widget._textEditingController.text);
                          }),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(color: Color(0XCC2A9D8F)),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: UIConstants.SMALL_PADDING,
                        vertical: UIConstants.SMALL_PADDING,
                      ),
                      itemBuilder: (context, index) => _buildMessageItem(
                          context,
                          state.messages[state.messages.length - 1 - index]),
                      itemCount: state.messages.length,
                      reverse: true,
                    ),
                  ),
                )
              ],
            );
          }
        },
        data: <String, dynamic>{'chatroomId': widget.chatroomId},
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, Message message) {
    final styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.lightBlueAccent,
      borderWidth: 1,
      elevation: 4,
      margin: BubbleEdges.only(top: 15, right: 50),
      alignment: Alignment.topLeft,
    );

    final styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      borderWidth: 1,
      elevation: 4,
      margin: BubbleEdges.only(top: 8, left: 50),
      alignment: Alignment.topRight,
    );

    if (message.value.startsWith("_uri:")) {
      final String url = message.value.substring("_uri:".length);
      if (message.outgoing) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.only(
            top: UIConstants.SMALL_PADDING,
            left: UIConstants.LARGE_PADDING,
          ),
          child: Image.network(url, width: 256.0),
        );
      } else {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.only(
            top: UIConstants.SMALL_PADDING,
            right: UIConstants.LARGE_PADDING,
          ),
          child: Image.network(url, width: 256.0),
        );
      }
    }
    if (message.outgoing) {
      if (message.author.imgURL != null && message.author.imgURL.length > 0) {
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Bubble(
                        style: styleMe,
                        child: Text(
                          message.value,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.end,
                        ))),
                SizedBox(width: 5),
                Image.network(message.author.imgURL, width: 35, height: 40),
              ],
            ));
      } else {
        return Bubble(
            style: styleMe,
            child: Text(
              message.value,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.end,
            ));
      }
    } else {
      if (message.option) {
        return Container(
          child: ButtonTheme(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, // background
                  onPrimary: Colors.white, // foreground
                  padding: EdgeInsets.all(UIConstants.SMALL_PADDING)),
              onPressed: () {
                ChatRepo.getInstance()
                    .deleteMessageAfterSelected(message)
                    .whenComplete(() => _send(context, message.value));
              },
              child: Text(
                message.value,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          margin: EdgeInsets.only(
            top: UIConstants.SMALL_PADDING,
            right: UIConstants.LARGE_PADDING,
          ),
        );
      }
      if (message.author.name == 'chatbot') {
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/icons/chatbot.png', width: 35, height: 40),
                SizedBox(width: 5),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Bubble(
                        style: styleSomebody,
                        child: Text(
                          message.value,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.end,
                        )))
              ],
            ));
      } else if (message.author.imgURL != null) {
        return Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(message.author.imgURL, width: 35, height: 40),
                SizedBox(width: 5),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Bubble(
                        style: styleSomebody,
                        child: Text(
                          message.value,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.end,
                        )))
              ],
            ));
      } else {
        return Bubble(
            style: styleSomebody,
            child: Text(
              message.value,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.end,
            ));
      }
      // return Container(
      //   child: Text(
      //     message.value,
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   decoration: BoxDecoration(
      //       color: Colors.blueAccent,
      //       borderRadius: BorderRadius.all(Radius.circular(6.0))),
      //   padding: EdgeInsets.all(UIConstants.SMALL_PADDING),
      //   margin: EdgeInsets.only(
      //     top: UIConstants.SMALL_PADDING,
      //     right: UIConstants.LARGE_PADDING,
      //   ),
      // );
    }
  }

  void _send(BuildContext context, String text) {
    if (text.isNotEmpty) {
      BlocProvider.of<InstantMessagingBloc>(context).send(text);
      widget._textEditingController.text = "";
    }
  }

  void _sendFile(BuildContext context, File file) {
    BlocProvider.of<InstantMessagingBloc>(context).sendFile(file);
  }

  void _openPictureDialog(BuildContext context) async {
    File target =
        File((await ImagePicker().getImage(source: ImageSource.gallery)).path);
    if (target != null) {
      _sendFile(context, target);
    }
  }
}

class IMTextEditingController extends TextEditingController {}
