import 'package:bloc/bloc.dart';
import 'package:proyecto_test_flutter_1/Data/data_source.dart';

import '../../../../Data/person_model.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final DataSource _dataSource;

  AppBloc(this._dataSource)
      : super(AppState(PeopleDataStatus.empty, AppMode.freeMode, const [])) {
    on<PersonCreated>(_onPersonCreated);
    on<PersonUpdated>(_onPersonUpdated);
    on<FreeModeSet>(_onFreeModeSet);
    on<UserModeSet>(_onUserModeSet);
    on<FormProcessed>(_onFormProcessed);
    on<InitBloc>(_onInitBloc);
  }

  _onInitBloc(InitBloc event, Emitter emit) async {
    await _fetchPeopleData(emit, state.appMode, state.usuario, state.dbStatus);
  }

  _onPersonCreated(PersonCreated event, Emitter emit) async {
    try {
      await _dataSource.addPerson(event.persona);
      emit(AppState(state.status, state.appMode, state.personas,
          usuario: state.usuario, dbStatus: DBStatus.success));
      await _fetchPeopleData(
          emit, state.appMode, state.usuario, DBStatus.success);
    } catch (e) {
      emit(AppState(state.status, state.appMode, state.personas,
          usuario: state.usuario, dbStatus: DBStatus.failure));
    }
  }

  _onPersonUpdated(PersonUpdated event, Emitter emit) async {
    try {
      await _dataSource.editPerson(event.persona);
      emit(AppState(state.status, state.appMode, state.personas,
          usuario: state.usuario, dbStatus: DBStatus.success));
      await _fetchPeopleData(
          emit, state.appMode, state.usuario, DBStatus.success);
    } catch (e) {
      emit(AppState(state.status, state.appMode, state.personas,
          usuario: state.usuario, dbStatus: DBStatus.failure));
    }
  }

  _onUserModeSet(UserModeSet event, Emitter emit) async {
    Persona? persona = await _dataSource.retrievePerson(event.usuario);
    if (persona == null) {
      await _dataSource.addPerson(Persona(usuario: event.usuario));
    }
    await _fetchPeopleData(
        emit, AppMode.userMode, event.usuario, DBStatus.unknown);
  }

  _onFreeModeSet(FreeModeSet event, Emitter emit) async {
    if (state.status.isAvailable) {
      emit(AppState(state.status, AppMode.freeMode, state.personas));
    } else {
      await _fetchPeopleData(emit, AppMode.freeMode, null, DBStatus.unknown);
    }
  }

  _fetchPeopleData(
      Emitter emit, AppMode appMode, String? usuario, DBStatus dbStatus) async {
    emit(AppState(PeopleDataStatus.loading, appMode, const [],
        usuario: usuario, dbStatus: dbStatus));
    final List<Persona> personas = await _dataSource.retrieveAll();
    emit(AppState(PeopleDataStatus.available, appMode, personas,
        usuario: usuario, dbStatus: dbStatus));
  }

  _onFormProcessed(FormProcessed event, Emitter<AppState> emit) {
    emit(AppState(state.status, state.appMode, state.personas,
        usuario: state.usuario, dbStatus: DBStatus.unknown));
  }
}
