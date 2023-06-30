import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_test_flutter_1/UI/navigation.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.white,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Image.asset('assets/people_drawing.jpg'),
      ),
      Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Opacity(
                opacity: 0.95,
                child: Card(
                  color: Colors.lightBlue.shade50,
                  child: Column(
                    children: [
                      const BoxRow(true),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        child: Text(
                          'Bienvenid@ a la app de las relaciones',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.deliciousHandrawn(
                              fontSize: 30, fontWeight: FontWeight.w300),
                        ),
                      ),
                      const BoxRow(false),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 270,
              ),
              const ButtonRow(),
            ],
          ),
        ),
      )
    ]);
  }
}

class BoxRow extends StatelessWidget {
  const BoxRow(this.firstColored, {super.key});

  final bool firstColored;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          12,
          (index) => SizedBox(
            width: 30,
            height: 25,
            child: (firstColored ? index.isEven : index.isOdd)
                ? Container(color: Colors.orange.shade400)
                : null,
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.lightBlue.shade50)),
            onPressed: () {},
            icon: const Icon(Icons.stars),
            label: const Text(
              "Modo libre",
              style: TextStyle(fontSize: 18),
            )),
        const SizedBox(width: 20),
        TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.lightBlue.shade50)),
            onPressed: () {
              context.goNamed(RouteNames.peoplePage);
            },
            icon: const Icon(Icons.person),
            label: const Text(
              "Modo usuario",
              style: TextStyle(fontSize: 18),
            )),
      ],
    );
  }
}
