import 'package:flutter/material.dart';

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
  final agregarRelacionTextEditingController = TextEditingController();

  List<String> relaciones = [];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: usuarioTextEditingController,
            ),
            TextFormField(
              controller: emailTextEditingController,
            ),
            TextFormField(
              controller: sobreMiTextEditingController,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [],
            ),
          ],
        ));
  }
}
