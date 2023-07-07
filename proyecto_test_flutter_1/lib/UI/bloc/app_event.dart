import 'package:proyecto_test_flutter_1/Data/person_model.dart';

sealed class AppEvent {}

class PeopleListRequested extends AppEvent {}

class PersonUpdated extends AppEvent {
  final Persona persona;
  PersonUpdated(this.persona);
}

class PersonCreated extends AppEvent {
  final Persona persona;
  PersonCreated(this.persona);
}

class UserModeSet extends AppEvent {
  final String usuario;
  UserModeSet(this.usuario);
}

class FreeModeSet extends AppEvent {}

class FormProcessed extends AppEvent {}

class InitBloc extends AppEvent {}
