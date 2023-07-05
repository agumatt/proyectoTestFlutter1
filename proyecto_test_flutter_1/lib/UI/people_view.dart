import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_test_flutter_1/UI/widgets/avatars.dart';

import '../Data/person_model.dart';
import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';

class PeopleView extends StatelessWidget {
  PeopleView({super.key});

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (!state.status.isAvailable) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        int peoplePerPage = 10;
        int numberOfPages = (state.personas.length / peoplePerPage).ceil();

        late final personasSeleccionadas;
        if (state.appMode.isUserMode) {
          Persona personaUsuario = state.personas
              .firstWhere((element) => element.usuario == state.usuario);
          personasSeleccionadas = state.personas
              .where((element) =>
                  personaUsuario.relaciones.contains(element.usuario))
              .toList();
        } else {
          personasSeleccionadas = state.personas;
        }
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.lightBlue,
              title: state.appMode.isUserMode
                  ? Text("Relaciones de ${state.usuario}")
                  : Text("Personas disponibles"),
            ),
            body: PageView(
                children: List.generate(numberOfPages, (index) {
              return PeoplePage(
                  personasSeleccionadas
                      .getRange(
                          index * peoplePerPage,
                          min<int>(index * peoplePerPage + peoplePerPage,
                              personasSeleccionadas.length))
                      .toList(),
                  index + 1,
                  numberOfPages);
            })));
      },
    );
  }
}

class PeoplePage extends StatelessWidget {
  const PeoplePage(this.personas, this.currentPage, this.numberOfPages,
      {super.key});

  final List<Persona> personas;
  final int currentPage;
  final int numberOfPages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 550,
          child: ListView(
            children: List.generate(
                personas.length,
                (index) => Hero(
                      tag: 'personDetails_${personas[index].usuario}',
                      child: ListTile(
                        title: Text(personas[index].usuario),
                        leading: AvatarWidget(personas[index].avatarIndex),
                        trailing: TextButton(
                          child: Text("Ver detalles"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PersonDetails(personas[index])));
                          },
                        ),
                      ),
                    )),
          ),
        ),
        Text("Página $currentPage de $numberOfPages"),
      ],
    );
  }
}

class PersonDetails extends StatelessWidget {
  const PersonDetails(this.persona, {super.key});

  final Persona persona;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.lightBlue,
      ),
      body: Column(children: [
        Hero(
          tag: 'personDetails_${persona.usuario}',
          child: Row(
            children: [
              AvatarWidget(persona.avatarIndex),
              Text(persona.usuario),
            ],
          ),
        )
      ]),
    );
  }
}
