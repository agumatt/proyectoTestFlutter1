import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_test_flutter_1/Data/person_model.dart';
import 'package:proyecto_test_flutter_1/Misc/constants.dart';
import 'package:proyecto_test_flutter_1/UI/bloc/app_event.dart';
import 'package:proyecto_test_flutter_1/UI/widgets/avatars.dart';

import 'bloc/app_bloc.dart';
import 'bloc/app_state.dart';

class PersonFormView extends StatefulWidget {
  const PersonFormView({super.key});

  @override
  State<PersonFormView> createState() => _PersonFormViewState();
}

class _PersonFormViewState extends State<PersonFormView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? agregarRelacionTextEditingController;
  String? usuario;
  String? sobreMi;
  String? email;
  int? avatarIndex;
  List<String>? relaciones;

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = context.read<AppBloc>();
    return BlocBuilder<AppBloc, AppState>(
        bloc: bloc,
        builder: (context, state) {
          if (!state.status.isAvailable) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: state.appMode.isFreeMode ? '' : state.usuario,
                    enabled: state.appMode.isFreeMode,
                    maxLength: 100,
                    decoration: InputDecoration(
                      label: const Text("Nombre de usuario"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onSaved: (newValue) {
                      usuario = newValue;
                    },
                    validator: (value) =>
                        value != '' ? null : 'Debes ingresar un usuario',
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: state.appMode.isFreeMode
                        ? ''
                        : state.personaUsuario?.email,
                    maxLength: 100,
                    validator: (value) =>
                        EmailValidator.validate(value ?? '') || value == ''
                            ? null
                            : "El correo ingresado no es válido",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: const Text("Correo electrónico"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onSaved: (newValue) {
                      email = newValue;
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      label: const Text("Mi avatar"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    value: state.appMode.isFreeMode
                        ? 0
                        : state.personaUsuario?.avatarIndex,
                    items: List.generate(
                        Avatars.numberOfAvatars,
                        (index) => DropdownMenuItem(
                            value: index,
                            child: Row(
                              children: [
                                AvatarWidget(index),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("Icono ${index + 1}"),
                              ],
                            ))),
                    onChanged: (value) {},
                    onSaved: (newValue) {
                      avatarIndex = newValue;
                    },
                    validator: (value) =>
                        value != null ? null : 'Debes escoger un avatar',
                  ),
                  const SizedBox(height: 15),
                  FormField<List<Persona>>(
                    initialValue: state.appMode.isFreeMode
                        ? []
                        : state.relacionesUsuario!,
                    onSaved: (newValue) {
                      relaciones = newValue!.map((e) => e.usuario).toList();
                    },
                    builder: (fieldState) => Column(
                      children: [
                        Autocomplete<Persona>(
                          onSelected: (option) {
                            agregarRelacionTextEditingController?.clear();
                            if (!fieldState.value!.contains(option)) {
                              var updatedList = fieldState.value;
                              updatedList!.add(option);
                              fieldState.didChange(updatedList);
                            }
                          },
                          displayStringForOption: (option) => option.usuario,
                          fieldViewBuilder: (context, textEditingController,
                              focusNode, onFieldSubmitted) {
                            agregarRelacionTextEditingController =
                                textEditingController;
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                  label: const Text("Agregar relación"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            );
                          },
                          optionsBuilder: (textEditingValue) {
                            List<Persona> filtered =
                                textEditingValue.text.isEmpty
                                    ? List.empty()
                                    : state.personas
                                        .where((persona) =>
                                            persona.usuario != state.usuario &&
                                            persona.usuario
                                                .toLowerCase()
                                                .contains(textEditingValue.text
                                                    .toLowerCase()))
                                        .toList();
                            return List.generate(
                              filtered.length,
                              (index) => filtered[index],
                            );
                          },
                        ),
                        Wrap(
                          children: List.generate(
                              fieldState.value?.length ?? 0,
                              (index) => Chip(
                                    onDeleted: () {
                                      var updatedList = fieldState.value;
                                      updatedList?.removeAt(index);
                                      fieldState.didChange(updatedList);
                                    },
                                    avatar: AvatarWidget(
                                        fieldState.value![index].avatarIndex),
                                    label:
                                        Text(fieldState.value![index].usuario),
                                  )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: state.appMode.isFreeMode
                        ? null
                        : state.personaUsuario?.sobreMi,
                    maxLines: 6,
                    maxLength: 400,
                    decoration: InputDecoration(
                      label: const Text("Sobre mí"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onSaved: (newValue) {
                      sobreMi = newValue;
                    },
                    restorationId: 'form_sobreMi',
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    child: const Text('Enviar'),
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        if (state.appMode.isFreeMode) {
                          bloc.add(PersonCreated(Persona(
                              usuario: usuario!,
                              email: email!,
                              sobreMi: sobreMi!,
                              avatarIndex: avatarIndex!,
                              relaciones: relaciones!)));
                        } else {
                          bloc.add(PersonUpdated(state.personaUsuario!.copyWith(
                              email: email!,
                              sobreMi: sobreMi!,
                              avatarIndex: avatarIndex!,
                              relaciones: relaciones!)));
                        }
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => BlocBuilder<AppBloc, AppState>(
                            bloc: bloc,
                            builder: (context, state) => WillPopScope(
                              onWillPop: () async {
                                bloc.add(FormProcessed());
                                return true;
                              },
                              child: AlertDialog(
                                content: switch (state.dbStatus) {
                                  DBStatus.unknown => const Center(
                                      child: CircularProgressIndicator()),
                                  DBStatus.success => const Text(
                                      "La información fue enviada con éxito"),
                                  DBStatus.failure =>
                                    const Text("Error al enviar la forma"),
                                },
                                actions: [
                                  TextButton(
                                      onPressed: state.dbStatus.isUnknown
                                          ? null
                                          : () {
                                              if (state.dbStatus.isSuccess) {
                                                formKey.currentState?.reset();
                                              }
                                              bloc.add(FormProcessed());
                                              Navigator.of(context).pop();
                                            },
                                      child: const Text("Cerrar"))
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ));
        });
  }
}
