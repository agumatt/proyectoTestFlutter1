import 'package:flutter/material.dart';

class PersonForm extends StatefulWidget {
  const PersonForm({super.key});

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final formKey = GlobalKey<FormState>();
  final nombresTextEditingController = TextEditingController();
  final apellidosTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final sobreMiTextEditingController = TextEditingController();
  final agregarRelacionTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nombresTextEditingController,
            ),
            TextFormField(
              controller: apellidosTextEditingController,
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
            )
          ],
        ));
  }
}
