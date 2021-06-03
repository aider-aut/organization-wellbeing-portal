import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/model/user/user.dart';

class MainState {
  final bool isLoading;
  final String name;
  final String tenant;
  final String profileImg;
  final Map<String, String> imageUrls;
  final SelectedChatroom selected;
  final List<User> employees;
  final bool loggedIn;

  MainState._internal(this.isLoading,
      {this.name: '',
      this.tenant: '',
      this.profileImg,
      this.imageUrls,
      this.loggedIn = true,
      this.selected,
      this.employees});

  factory MainState.initial() => MainState._internal(true);
  factory MainState.update(String name, String profileImg, String tenant,
          Map<String, String> imageUrls) =>
      MainState._internal(false,
          name: name,
          profileImg: profileImg,
          tenant: tenant,
          imageUrls: imageUrls);
  factory MainState.updateEmployees(
          bool isLoading, List<User> employees, MainState state) =>
      MainState._internal(isLoading,
          name: state.name,
          profileImg: state.profileImg,
          tenant: state.tenant,
          imageUrls: state.imageUrls,
          employees: employees);
  factory MainState.isLoading(bool isLoading, MainState state) =>
      MainState._internal(isLoading,
          name: state.name,
          profileImg: state.profileImg,
          tenant: state.tenant,
          imageUrls: state.imageUrls);
  factory MainState.enterChatroom(SelectedChatroom chatroom, MainState state) =>
      MainState._internal(false, name: state.name, selected: chatroom);
  factory MainState.logout(MainState state) =>
      MainState._internal(false, name: state.name, loggedIn: false);
  factory MainState.reset(MainState state) =>
      MainState._internal(state.isLoading, name: state.name);
}
