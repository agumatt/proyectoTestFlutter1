import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_test_flutter_1/Data/person_model.dart';
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
  final usuarioTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final sobreMiTextEditingController = TextEditingController();
  TextEditingController? agregarRelacionTextEditingController;
  int? selectedAvatar = 0;

  List<Persona> relaciones = [];

  @override
  void dispose() {
    usuarioTextEditingController.dispose();
    emailTextEditingController.dispose();
    sobreMiTextEditingController.dispose();
    agregarRelacionTextEditingController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) => Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: usuarioTextEditingController,
                maxLength: 100,
                decoration: InputDecoration(
                  label: Text("Nombre de usuario"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: emailTextEditingController,
                maxLength: 100,
                validator: (value) => EmailValidator.validate(value ?? '')
                    ? null
                    : "El correo ingresado no es válido",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  label: Text("Correo electrónico"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text("Mi avatar"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                value: selectedAvatar,
                items: List.generate(
                    5,
                    (index) => DropdownMenuItem(
                        value: index,
                        child: Row(
                          children: [
                            AvatarWidget(index),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Icono ${index + 1}"),
                          ],
                        ))),
                onChanged: (value) {
                  selectedAvatar = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Autocomplete<Persona>(
                onSelected: (option) {
                  agregarRelacionTextEditingController?.clear();
                  if (!relaciones.contains(option)) {
                    setState(() {
                      relaciones.add(option);
                    });
                  }
                },
                displayStringForOption: (option) => option.usuario,
                fieldViewBuilder: (context, textEditingController, focusNode,
                    onFieldSubmitted) {
                  agregarRelacionTextEditingController = textEditingController;
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                        label: Text("Agregar relación"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  );
                },
                optionsBuilder: (textEditingValue) {
                  List<Persona> filtered = textEditingValue.text.isEmpty
                      ? List.empty()
                      : state.personas
                          .where((persona) =>
                              persona.usuario != state.usuario &&
                              persona.usuario.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()))
                          .toList();
                  return List.generate(
                    filtered.length,
                    (index) => filtered[index],
                  );
                },
              ),
              Wrap(
                children: List.generate(
                    relaciones.length,
                    (index) => Chip(
                          onDeleted: () {
                            setState(() {
                              relaciones.removeAt(index);
                            });
                          },
                          avatar: AvatarWidget(relaciones[index].avatarIndex),
                          label: Text(relaciones[index].usuario),
                        )),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: sobreMiTextEditingController,
                maxLines: 6,
                maxLength: 400,
                decoration: InputDecoration(
                  label: Text("Sobre mí"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          )),
    );
  }
}
