sealed class AppModeEvent {}

class UserModeSet extends AppModeEvent {
  final String user;

  UserModeSet(this.user);
}

class FreeModeSet extends AppModeEvent {}
