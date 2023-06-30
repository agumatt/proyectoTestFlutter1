import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:proyecto_test_flutter_1/Domain/app_mode_event.dart';
import 'package:proyecto_test_flutter_1/Domain/app_mode_state.dart';

class AppModeBloc extends Bloc<AppModeEvent, AppModeState> {
  AppModeBloc() : super(FreeMode()) {
    on<FreeModeSet>(_onFreeModeSet);
    on<UserModeSet>(_onUserModeSet);
  }

  FutureOr<void> _onFreeModeSet(FreeModeSet event, Emitter<AppModeState> emit) {
    emit(FreeMode());
  }

  FutureOr<void> _onUserModeSet(UserModeSet event, Emitter<AppModeState> emit) {
    emit(UserMode(event.user));
  }
}
