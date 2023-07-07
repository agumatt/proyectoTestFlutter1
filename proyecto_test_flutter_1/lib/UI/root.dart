import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_test_flutter_1/Data/sql_data_source.dart';
import 'package:proyecto_test_flutter_1/UI/bloc/app_event.dart';

import 'navigation.dart';
import 'bloc/app_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
        create: (context) => AppBloc(SQLdataSource()),
        child: Builder(builder: (context) {
          context.read<AppBloc>().add(InitBloc());
          return MaterialApp.router(
            routerConfig: router,
            restorationScopeId: 'root',
          );
        }));
  }
}
