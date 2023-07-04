import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:proyecto_test_flutter_1/Data/data_source.dart';

import '../../../../Data/person_model.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final DataSource _dataSource;

  AppBloc(this._dataSource)
      : super(AppState(PeopleDataStatus.empty, AppMode.freeMode, const [])) {
    on<PersonCreatedOrUpdated>(_onPersonCreatedOrUpdated);
    on<FreeModeSet>(_onFreeModeSet);
    on<UserModeSet>(_onUserModeSet);
  }

  _onPersonCreatedOrUpdated(PersonCreatedOrUpdated event, Emitter emit) async {
    if (await _dataSource.retrievePerson(event.persona.usuario) == null) {
      await _dataSource.addPerson(event.persona);
    } else {
      await _dataSource.editPerson(event.persona);
    }
    _fetchPeopleData(emit, state.appMode, state.usuario);
  }

  _onUserModeSet(UserModeSet event, Emitter emit) async {
    Persona? persona = await _dataSource.retrievePerson(event.usuario);
    if (persona == null) {
      await _dataSource.addPerson(Persona(usuario: event.usuario));
    }
    _fetchPeopleData(emit, AppMode.userMode, event.usuario);
  }

  _onFreeModeSet(FreeModeSet event, Emitter emit) async {
    _fetchPeopleData(emit, AppMode.freeMode, null);
  }

  _fetchPeopleData(Emitter emit, AppMode appMode, String? usuario) async {
    emit(AppState(PeopleDataStatus.loading, appMode, const [],
        usuario: usuario));
    final List<Persona> personas = await _dataSource.retrieveAll();
    emit(AppState(PeopleDataStatus.available, appMode, personas,
        usuario: usuario));
  }
}
