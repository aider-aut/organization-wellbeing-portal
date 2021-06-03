import 'package:chatapp/model/user/user.dart';

abstract class MainEvent {}

class ClearChatroomsEvent extends MainEvent {}

class MainUpdateEventInProgress extends MainEvent {}

class MainUpdateEvent extends MainEvent {
  MainUpdateEvent(this.name, this.profileImg, this.tenant, this.imageUrls);
  final String name;
  final String tenant;
  final String profileImg;
  final Map<String, String> imageUrls;
}

class MainEmployeesListUpdate extends MainEvent {
  MainEmployeesListUpdate(this.employees);
  final List<User> employees;
}

class MainErrorEvent extends MainEvent {}
