import 'package:equatable/equatable.dart';

sealed class AppModeState extends Equatable {}

class FreeMode extends AppModeState {
  @override
  List<Object?> get props => [];
}

class UserMode extends AppModeState {
  final String user;
  UserMode(this.user);

  @override
  List<Object?> get props => [user];
}
