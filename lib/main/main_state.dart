import 'package:chatapp/model/chat/chatroom.dart';

class MainState {
  final bool isLoading;
  final String name;
  final String profileImg;
  final Map<String, String> imageUrls;
  final SelectedChatroom selected;
  final bool loggedIn;

  MainState._internal(this.isLoading,
      {this.name: '',
      this.profileImg,
      this.imageUrls,
      this.loggedIn = true,
      this.selected});

  factory MainState.initial() => MainState._internal(false);
  factory MainState.update(String name, String profileImg,
          Map<String, String> imageUrls, MainState state) =>
      MainState._internal(false,
          name: name, profileImg: profileImg, imageUrls: imageUrls);
  factory MainState.isLoading(bool isLoading, MainState state) =>
      MainState._internal(isLoading,
          name: state.name,
          profileImg: state.profileImg,
          imageUrls: state.imageUrls);
  factory MainState.enterChatroom(SelectedChatroom chatroom, MainState state) =>
      MainState._internal(false, name: state.name, selected: chatroom);
  factory MainState.logout(MainState state) =>
      MainState._internal(false, name: state.name, loggedIn: false);
  factory MainState.reset(MainState state) =>
      MainState._internal(state.isLoading, name: state.name);
}
